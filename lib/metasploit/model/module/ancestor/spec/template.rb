class Metasploit::Model::Module::Ancestor::Spec::Template < Metasploit::Model::Spec::Template
  #
  # CONSTANTS
  #

  # Default value for {Metasploit::Model::Spec::Template#search_pathnames}.
  DEFAULT_SEARCH_PATHNAMES = [
      Pathname.new('module/ancestors')
  ]
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

  def destination_pathname
    unless instance_variable_defined? :@destination_pathname
      @destination_pathname = nil

      if module_ancestor
        @destination_pathname = module_ancestor.real_pathname
      end
    end

    @destination_pathname
  end

  def locals
    @locals ||= {
        metasploit_module_relative_name: metasploit_module_relative_name,
        module_ancestor: module_ancestor
    }
  end

  def metasploit_module_relative_name
    @metasploit_module_relative_name ||= FactoryGirl.generate :metasploit_model_module_ancestor_metasploit_module_relative_name
  end

  def overwrite
    unless instance_variable_defined? :@overwrite
      @overwrite = false
    end

    @overwrite
  end

  def search_pathnames
    @search_pathnames ||= DEFAULT_SEARCH_PATHNAMES.dup
  end

  def source_relative_name
    @source_relative_name ||= DEFAULT_SOURCE_RELATIVE_NAME
  end
end