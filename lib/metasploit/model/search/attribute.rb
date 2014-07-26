module Metasploit
  module Model
    module Search
      # Registers attributes that can be searched.  Attributes must be declared to be searchable as a type from
      # {Metasploit::Model::Search::Operator::Attribute::TYPES}.  The type of the attribute is used to select a
      # type-specific {Metasploit::Model::Search::Operation}, which will validate the
      # {Metasploit::Model::Search::Operation::Base#value} is of the valid type.
      #
      # # Set attributes
      #
      # Search attributes declared as having an integer set or string set type integer or string set require a
      # `<attribute>_set` method to be defined on the `Class`, which returns the set of allowed values for the search
      # attribute's operation.  This method will be called, indirectly by
      # {Metasploit::Model::Search::Operation::Set::Integer}'s and {Metasploit::Model::Search::Operation::Set::String}'s
      # validations.
      #
      # # Help
      #
      # The help for each operator is uses the `I18n` system, so the help for an attribute operator on a given class can
      # added to `config/locales/<lang>.yml`.  The scope of the lookup, under the language key is the `Class`'s
      # `i18n_scope`, which is `metasploit.model` if the `Class` includes {Metasploit::Model::Translation} or
      # `active_record` for `ActiveRecord::Base` subclasses.  Under the `i18n_scope`, any `Module#ancestor`'s
      # `model_name.i18n_key` can be used to look up the help for an attribute's operator.  This allows for super
      # classes or mixins to define the search operator help for subclasses.
      #
      #     # config/locales/<lang>.yml
      #     <lang>:
      #       <Class#i18n_scope>:
      #         ancestors:
      #           <ancestor.model_name.i18n_key>:
      #             search:
      #               operator:
      #                 names:
      #                   <attribute>:
      #                     help: "The attribute on the class"
      #
      # # Testing
      #
      # {ClassMethods#search_attribute} calls can be tested with the 'search_attribute' shared example.  First, ensure
      # the shared examples from `metasploit-model` are required in your `spec_helper.rb`:
      #
      #     # spec/spec_helper.rb
      #     support_glob = Metasploit::Model::Engine.root.join('spec', 'support', '**', '*.rb')
      #
      #     Dir.glob(support_glob) do |path|
      #       require path
      #     end
      #
      # In the spec for the `Class` that called `search_attribute`, use the 'search_attribute' shared example by
      # passing that arguments passed to {ClassMethods#search_attribute}.
      #
      #     # spec/app/models/my_class_spec.rb
      #     require 'spec_helper'
      #
      #     describe MyClass do
      #       context 'search' do
      #         context 'attributes' do
      #           it_should_behave_like 'search_attribute',
      #                                 type: {
      #                                   set: :string
      #                                 }
      #         end
      #       end
      #     end
      module Attribute
        extend ActiveSupport::Concern

        include Metasploit::Model::Search::With

        # Adds {#search_attribute} DSL to make {Metasploit::Model::Search::Operator::Attribute attribute search
        # operators}.
        module ClassMethods
          # Registers attribute for search.  Help for the operator supports i18n.
          #
          # @example defining help
          #    # lib/metasploit/model/module/instance.rb
          #    module Metasploit::Model::Module::Instance
          #      include Metasploit::Model::Search
          #
          #      included do
          #        search_attribute :description, type: :string
          #      end
          #    end
          #
          #    # config/locales/en.yml
          #    en:
          #      metasploit:
          #        model:
          #          module:
          #            instance:
          #              search_attribute:
          #                description:
          #                  help: "A long, paragraph description of what the module does."
          #
          # @param attribute [#to_sym] name of attribute to search.
          # @param options [Hash{Symbol => String}]
          # @option options [Symbol] :type The type of the attribute.  Used to determine how to parse the search values
          #   and which modifiers are supported.
          # @return (see Metasploit::Model::Search::With::ClassMethods#search_with)
          # @raise [Metasploit::Model::Invalid] unless attribute is present
          # @raise [Metasploit::Model::Invalid] unless :type is present
          def search_attribute(attribute, options={})
            search_with Metasploit::Model::Search::Operator::Attribute,
                        :attribute => attribute,
                        :type => options[:type]
          end
        end
      end
    end
  end
end