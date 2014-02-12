class Metasploit::Model::Module::Class::Spec::Template < Metasploit::Model::Base
  #
  # Attributes
  #

  # @!attribute [rw] module_class
  #   The {Metasploit::Model::Module::Class} whose {Metasploit::Model::Module::Class#ancestors} need to be templated in
  #   {#module_ancestor_templates}.
  #
  #   @return [Metasploit::Model::Module::Class]
  attr_accessor :module_class

  #
  # Validations
  #

  validates :module_class,
            presence: true
  validate :ancestor_templates_valid

  #
  # Methods
  #

  def ancestor_templates
    unless instance_variable_defined? :@ancestor_templates
      if module_class
        @ancestor_templates = module_class.ancestors.collect { |module_ancestor|
          Metasploit::Model::Module::Ancestor::Spec::Template.new(
              module_ancestor: module_ancestor
          ).tap { |module_ancestor_template|
            module_ancestor_template.locals[:module_class] = module_class
            module_ancestor_template.overwrite = true

            module_ancestor_template.search_pathnames.unshift(
                Pathname.new('module/classes')
            )
          }
        }
      end

      @ancestor_templates ||= []
    end

    @ancestor_templates
  end

  # Writes {#ancestor_templates} for :module_class to disk if each {Metasploit::Model::Module::Ancestor::Spec::Template}
  # is valid.
  #
  # @param attributes [Hash{Symbol => Object}] Attributes passed to `new`.
  # @
  def self.write(attributes={})
    template = new(attributes)

    written = template.valid?

    if written
      template.write
    end

    written
  end

  # Writes {#ancestor_templates} to disk.
  #
  # @return [void]
  # @raise (see Metasploit::Model::Spec::Template)
  def write
    ancestor_templates.each(&:write)
  end

  private

  # Validates that all {#ancestor_templates} are valid.
  #
  # @return [void]
  def ancestor_templates_valid
    # can't use ancestor_templates.all?(&:valid?) as it will short-circuit and want all ancestor_templates to have
    # validation errors
    valids = ancestor_templates.map(&:valid?)

    unless valids.all?
      errors.add(:ancestor_templates, :invalid, value: ancestor_templates)
    end
  end
end