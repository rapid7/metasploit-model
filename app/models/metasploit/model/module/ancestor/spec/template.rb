# Writes templates for the {#module_ancestor} to disk.
#
# @example Update files after changing
#   module_ancestor = FactoryGirl.build(
#     :dummy_module_ancestor
#   )
#   # factory already wrote template when build returned
#
#   # update
#   module_ancestor.module_type = FactoryGirl.generate :metasploit_model_module_type
#
#   # Now the template on disk is different than the module_ancestor, so regenerate the template
#   Metasploit::Model::Module::Ancestor::Spec::Template.write(module_ancestor: module_ancestor)
class Metasploit::Model::Module::Ancestor::Spec::Template < Metasploit::Model::Spec::Template
  extend Metasploit::Model::Spec::Template::Write

  #
  # CONSTANTS
  #

  # Default value for {#search_pathnames}.
  DEFAULT_SEARCH_PATHNAMES = [
      Pathname.new('module/ancestors')
  ]
  # Default value for {#source_relative_name}.
  DEFAULT_SOURCE_RELATIVE_NAME = 'base'

  #
  # Attributes
  #

  # @!attribute [rw] metasploit_module_relative_name
  #   The name of the Class/Module in the template.  Defaults to
  #   `FactoryGirl.generate :metasploit_model_module_ancestor_metasploit_module_relative_name`.
  #
  #   @return [String]
  attr_writer :metasploit_module_relative_name

  # @!attribute [rw] module_ancestor
  #   The module ancestor to write.
  #
  #   @return [Metasploit::Model::Module::Ancestor]
  attr_accessor :module_ancestor

  #
  # Validations
  #

  validates :module_ancestor,
            presence: true

  #
  # Methods
  #

  # The pathname where to {#write} to template results.
  #
  # @return [Pathname] `Metasploit::Model::Module::Ancestor#real_pathname.
  # @return [nil] if {#module_ancestor} is `nil`.
  # @return [nil] if {#module_ancestor #module_ancestor's} `Metasploit::Model::Module::Ancestor#real_pathname` is `nil`
  #   after derivation.
  def destination_pathname
    unless instance_variable_defined? :@destination_pathname
      @destination_pathname = nil

      if module_ancestor
        destination_pathname = module_ancestor.real_pathname

        unless destination_pathname
          # validate to derive real_path and therefore real_pathname
          module_ancestor.valid?

          destination_pathname = module_ancestor.real_pathname
        end

        @destination_pathname = destination_pathname
      end
    end

    @destination_pathname
  end

  # Local variables exposed to partials.
  #
  # @return [Hash{Symbol => Object}] {#metasploit_module_relative_name} as :metasploit_module_relative_name and
  #   {#module_ancestor} at :module_ancestor.
  def locals
    @locals ||= {
        metasploit_module_relative_name: metasploit_module_relative_name,
        module_ancestor: module_ancestor
    }
  end

  # Name of the Class/Module declared in the template file.
  #
  # @return [String]
  def metasploit_module_relative_name
    @metasploit_module_relative_name ||= FactoryGirl.generate :metasploit_model_module_ancestor_metasploit_module_relative_name
  end

  # Whether to overwrite a pre-existing file.
  #
  # @return [Boolean] Defaults to `false` since nothing should write the template before the ancestor.
  def overwrite
    unless instance_variable_defined? :@overwrite
      @overwrite = false
    end

    @overwrite
  end

  # Pathnames to search for partials.
  #
  # @return [Array<Pathname>]  {DEFAULT_SEARCH_PATHNAMES}
  def search_pathnames
    @search_pathnames ||= DEFAULT_SEARCH_PATHNAMES.dup
  end

  # Name of template under {#search_pathnames} without {EXTENSION}.
  #
  # @return [String] Defaults to {DEFAULT_SOURCE_RELATIVE_NAME}.
  def source_relative_name
    @source_relative_name ||= DEFAULT_SOURCE_RELATIVE_NAME
  end
end