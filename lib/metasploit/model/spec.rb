require 'rspec/core/shared_example_group'

# Helper methods for running specs for metasploit-model.
module Metasploit::Model::Spec
  extend ActiveSupport::Autoload

  autoload :Error
  autoload :I18nExceptionHandler
  autoload :PathnameCollision
  autoload :Template
  autoload :TemporaryPathname

  extend Metasploit::Model::Spec::TemporaryPathname
  # without this, Module.shared_examples_for will be used and RSpec will count shared_examples created with
  # {shared_examples_for} to not be declared at the top-level.
  extend RSpec::Core::SharedExampleGroup::TopLevelDSL

  # Defines a shared examples for a `Module` under the {Metasploit::Model} namespace.  This `Module` is assumed to
  # be a mixin that can be mixed into an ActiveModel in metasploit-framework or an ActiveRecord in
  # metasploit_data_models.  Shared examples declared using this method get access to boiler plate methods used
  # for all the {Metasploit::Model} mixin `Modules`:
  #
  #   * <relative_variable_name>_class
  #   * <relative_variable_name>_factory
  #   * factory_namespace
  #   * relative_variable_name
  #   * #<relative_variable_name>_class
  #   * #<relative_variable_name>_factory
  #
  # @example boiler plate methods for Module::Ancestor
  #   # defined shared example's name will be 'Metasploit::Model::Module::Ancestor', but you only need to give the
  #   # name relative to 'Metasploit::Model'.
  #   Metasploit::Model::Spec.shared_examples_for 'Module::Ancestor' do
  #     module_ancestor_class # '<namespace_name>::Module::Ancestor'
  #     module_ancestor_factory # '<factory_namespace>_module_ancestor'
  #     factory_namespace # namespace_name converted to underscore with / replaced by _
  #     relative_variable_name # 'module_ancestor'
  #
  #     let(:base_class) do # automatically defined for you
  #       module_ancestor_class # same as class method module_ancestor_class
  #     end
  #
  #     context 'factories' do # have to define this yourself since not all mixins use factories.
  #       context module_ancestor_factory do # using class method
  #         subject(module_ancestor_factory) do # using class method
  #           FactoryGirl.build(module_ancestor_factory) # using instance method
  #         end
  #       end
  #     end
  #   end
  #
  # @example Using shared example
  #   describe Metasploit::Model::Module::Ancestor do
  #     it_should_behave_like 'Metasploit::Model::Module::Ancestor',
  #                           namespace_name: 'Dummy'
  #   end
  #
  # @param relative_name [String] name relative to 'Metasploit::Model' prefix.  For example, to declare
  #   'Metasploit::Model::Module::Ancestor' shared example, `relative_name` would be just 'Module::Ancestor'.
  # @yield Body of shared examples.
  # @yieldreturn [void]
  # @return [void]
  def self.shared_examples_for(relative_name, &block)
    fully_qualified_name = "Metasploit::Model::#{relative_name}"

    relative_variable_name = relative_name.underscore.gsub('/', '_')
    class_method_name = "#{relative_variable_name}_class"
    factory_method_name = "#{relative_variable_name}_factory"

    # capture block to pass to super so that source_location can be overridden to be block's source_location so that
    # errors are reported correctly from RSpec.
    wrapper = ->(options={}) {
      options.assert_valid_keys(:namespace_name)
      namespace_name = options.fetch(:namespace_name)

      class_name = "#{namespace_name}::#{relative_name}"

      #
      # Singleton methods to emulate local variable used to define examples and lets
      #

      define_singleton_method(class_method_name) do
        class_name.constantize
      end

      define_singleton_method(factory_method_name) do
        "#{factory_namespace}_#{relative_variable_name}"
      end

      define_singleton_method(:factory_namespace) do
        namespace_name.underscore.gsub('/', '_')
      end

      define_singleton_method(:namespace_name) do
        namespace_name
      end

      define_singleton_method(:relative_variable_name) do
        relative_variable_name
      end

      #
      # Defines to emulate local variable used inside lets
      #

      define_method(class_method_name) do
        self.class.send(class_method_name)
      end

      define_method(factory_method_name) do
        self.class.send(factory_method_name)
      end

      #
      # Default subject uses factory
      #

      subject(relative_variable_name) do
        FactoryGirl.build(send(factory_method_name))
      end

      #
      # lets
      #

      let(:base_class) do
        self.class.send(class_method_name)
      end

      it_should_behave_like 'Metasploit::Model::Translation',
                            metasploit_model_ancestor: fully_qualified_name.constantize

      module_eval(&block)
    }

    # Delegate source_location so that RSpec will report block's source_location as the declaration location of
    # the shared location instead of this method.
    wrapper.define_singleton_method(:source_location) do
      block.source_location
    end

    super(fully_qualified_name, &wrapper)
  end
end
