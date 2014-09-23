# Writes templates for the {#module_instance #module_instance's}
# {Metasploit::Model::Module::Instance#module_class #module_class's} {Metasploit::Model::Module::Class#ancestors} to
# disk.
#
# @example Update files after changing associations
#   module_instance = FactoryGirl.build(
#     :dummy_module_instance,
#     module_architectures_length: 0
#   )
#   # factory already wrote template when build returned
#
#   # update associations
#   architecture = FactoryGirl.generate :dummy_architecture
#   module_instance.module_architectures = FactoryGirl.build_list(
#     :dummy_module_architecture,
#     1,
#     architecture: architecture
#   )
#
#   # Now the template on disk is different than the module_instance, so regenerate the template
#   Metasploit::Model::Module::Instance::Spec::Template.write(module_instance: module_instance)
class Metasploit::Model::Module::Instance::Spec::Template < Metasploit::Model::Base
  extend Metasploit::Model::Spec::Template::Write

  #
  # Attributes
  #

  # @!attribute [rw] module_instance
  #   The {Metasploit::Model::Module::Instance} whose {Metasploit::Model::Module::Instance#module_class} needs to be
  #   templated in {#class_template}.
  #
  #   @return [Metasploit::Model::Module::Instance]
  attr_accessor :module_instance

  #
  # Validations
  #

  validates :class_template,
            presence: true
  validates :module_instance,
            presence: true
  validate :class_template_valid

  #
  # Methods
  #

  # Template for {#module_instance} {Metasploit::Model::Module::Instance#module_class} with the addition of
  # {#module_instance} to the {Metasploit::Model::Spec::Template#locals} and adding 'module/instances' to the front of
  # the {Metasploit::Model::Spec::Template#search_pathnames}.
  #
  # @return [Metasploit::Model::Module::Class::Spec::Template] if {#module_instance} present.
  # @return [nil] if {#module_instance} is `nil`.
  def class_template
    unless instance_variable_defined? :@class_template
      if module_instance
        class_template = Metasploit::Model::Module::Class::Spec::Template.new(
            module_class: module_instance.module_class
        )
        class_template.ancestor_templates.each do |ancestor_template|
          ancestor_template.locals[:module_instance] = module_instance

          ancestor_template.search_pathnames.unshift(
              Pathname.new('module/instances')
          )
        end

        @class_template = class_template
      else
        @class_template = nil
      end
    end

    @class_template
  end

  # @!method write
  #   Writes {#class_template} to disk.
  #
  #   @return [void]
  #   @raise (see Metasploit::Model::Spec::Template)
  delegate :write,
           to: :class_template

  private

  # Validates that {#class_template} is valid when present.
  #
  # @return [void]
  def class_template_valid
    if class_template && !class_template.valid?
      errors.add(:class_template, :invalid, value: class_template)
    end
  end
end