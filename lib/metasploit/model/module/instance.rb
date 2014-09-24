# Code shared between `Mdm::Module::Instance` and `Metasploit::Framework::Module::Instance`.
module Metasploit::Model::Module::Instance
  extend ActiveModel::Naming
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  include Metasploit::Model::Translation

  autoload :Spec

  #
  # CONSTANTS
  #

  # {#dynamic_length_validation_options} by {#module_type} by attribute.
  DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE = {
      actions: {
          Metasploit::Model::Module::Type::AUX => {
              minimum: 0
          },
          Metasploit::Model::Module::Type::ENCODER => {
              is: 0
          },
          Metasploit::Model::Module::Type::EXPLOIT => {
              is: 0
          },
          Metasploit::Model::Module::Type::NOP => {
              is: 0
          },
          Metasploit::Model::Module::Type::PAYLOAD => {
              is: 0
          },
          Metasploit::Model::Module::Type::POST => {
              minimum: 0
          }
      },
      module_architectures: {
          Metasploit::Model::Module::Type::AUX => {
              is: 0
          },
          Metasploit::Model::Module::Type::ENCODER => {
              minimum: 1
          },
          Metasploit::Model::Module::Type::EXPLOIT => {
              minimum: 1
          },
          Metasploit::Model::Module::Type::NOP => {
              minimum: 1
          },
          Metasploit::Model::Module::Type::PAYLOAD => {
              minimum: 1
          },
          Metasploit::Model::Module::Type::POST => {
              minimum: 1
          }
      },
      module_platforms: {
          Metasploit::Model::Module::Type::AUX => {
              is: 0
          },
          Metasploit::Model::Module::Type::ENCODER => {
              is: 0
          },
          Metasploit::Model::Module::Type::EXPLOIT => {
              minimum: 1
          },
          Metasploit::Model::Module::Type::NOP => {
              is: 0
          },
          Metasploit::Model::Module::Type::PAYLOAD => {
              minimum: 1
          },
          Metasploit::Model::Module::Type::POST => {
              minimum: 1
          }
      },
      module_references: {
          Metasploit::Model::Module::Type::AUX => {
              minimum: 0
          },
          Metasploit::Model::Module::Type::ENCODER => {
              is: 0
          },
          Metasploit::Model::Module::Type::EXPLOIT => {
              minimum: 1
          },
          Metasploit::Model::Module::Type::NOP => {
              is: 0
          },
          Metasploit::Model::Module::Type::PAYLOAD => {
              is: 0
          },
          Metasploit::Model::Module::Type::POST => {
              minimum: 0
          }
      },
      targets: {
          Metasploit::Model::Module::Type::AUX => {
              is: 0
          },
          Metasploit::Model::Module::Type::ENCODER => {
              is: 0
          },
          Metasploit::Model::Module::Type::EXPLOIT => {
              minimum: 1
          },
          Metasploit::Model::Module::Type::NOP => {
              is: 0
          },
          Metasploit::Model::Module::Type::PAYLOAD => {
              is: 0
          },
          Metasploit::Model::Module::Type::POST => {
              is: 0
          }
      }
  }

  # Minimum length of {#module_authors}.
  MINIMUM_MODULE_AUTHORS_LENGTH = 1

  # {#privileged} is Boolean so, valid values are just `true` and `false`, but since both the validation and
  # factory need an array of valid values, this constant exists.
  PRIVILEGES = [
      false,
      true
  ]

  # Member of {Metasploit::Model::Module::Type::ALL} that require {#stance} to be non-`nil`.
  STANCED_MODULE_TYPES = [
      Metasploit::Model::Module::Type::AUX,
      Metasploit::Model::Module::Type::EXPLOIT
  ]

  included do
    include ActiveModel::Validations
    include Metasploit::Model::Search

    #
    #
    # Search
    #
    #

    #
    # Search Associations
    #

    search_association :actions
    search_association :architectures
    search_association :authorities
    search_association :authors
    search_association :email_addresses
    search_association :module_class
    search_association :platforms
    search_association :rank
    search_association :references
    search_association :targets

    #
    # Search Attributes
    #

    search_attribute :description, :type => :string
    search_attribute :disclosed_on, :type => :date
    search_attribute :license, :type => :string
    search_attribute :name, :type => :string
    search_attribute :privileged, :type => :boolean
    search_attribute :stance, :type => :string

    #
    # Search Withs
    #

    search_with Metasploit::Model::Search::Operator::Deprecated::App
    search_with Metasploit::Model::Search::Operator::Deprecated::Author
    search_with Metasploit::Model::Search::Operator::Deprecated::Authority,
                :abbreviation => :bid
    search_with Metasploit::Model::Search::Operator::Deprecated::Authority,
                :abbreviation => :cve
    search_with Metasploit::Model::Search::Operator::Deprecated::Authority,
                :abbreviation => :edb
    search_with Metasploit::Model::Search::Operator::Deprecated::Authority,
                :abbreviation => :osvdb
    search_with Metasploit::Model::Search::Operator::Deprecated::Platform,
                :name => :os
    search_with Metasploit::Model::Search::Operator::Deprecated::Platform,
                :name => :platform
    search_with Metasploit::Model::Search::Operator::Deprecated::Ref
    search_with Metasploit::Model::Search::Operator::Deprecated::Text

    #
    #
    # Validations
    #
    #

    #
    # Method Validations
    #

    validate :architectures_from_targets,
             if: 'allows?(:targets)'
    validate :platforms_from_targets,
             if: 'allows?(:targets)'

    #
    # Attribute Validations
    #

    validates :actions,
              dynamic_length: true
    validates :description,
              :presence => true
    validates :license,
              :presence => true
    validates :module_architectures,
              dynamic_length: true
    validates :module_authors,
              :length => {
                  :minimum => MINIMUM_MODULE_AUTHORS_LENGTH
              }
    validates :module_class,
              :presence => true
    validates :module_platforms,
              dynamic_length: true
    validates :module_references,
              dynamic_length: true
    validates :name,
              :presence => true
    validates :privileged,
              :inclusion => {
                  :in => PRIVILEGES
              }
    validates :stance,
              inclusion: {
                  if: :stanced?,
                  in: Metasploit::Model::Module::Stance::ALL
              },
              nil: {
                  unless: :stanced?
              }
    validates :targets,
              dynamic_length: true
  end

  #
  #
  # Associations
  #
  #

  # @!attribute [rw] actions
  #   Auxiliary actions to perform when this running this module.
  #
  #   @return [Array<Metasploit::Model::Module::Action>]

  # @!attribute [rw] default_action
  #   The default action in {#actions}.
  #
  #   @return [Metasploit::Model::Module::Action]

  # @!attribute [rw] default_target
  #   The default target in {#targets}.
  #
  #   @return [Metasploit::Model::Module::Target]

  # @!attribute [rw] module_architectures
  #   Joins this with {#architectures}.
  #
  #   @return [Array<Metasploit::Model::Module::Architecture>]

  # @!attribute [rw] module_authors
  #   Joins this with {#authors} and {#email_addresses} to model the name and email address used for an author
  #   entry in the module metadata.
  #
  #   @return [Array<Metasploit::Model::Module::Author>]

  # @!attribute [rw] module_class
  #   Class-derived metadata to go along with the instance-derived metadata in this model.
  #
  #   @return [Metasploit::Model::Module::Class]

  # @!attribute [rw] module_platforms
  #   Joins this with {#platforms}.
  #
  #   @return [Array<Metasploit::Model::Module::Platform>]

  # @!attribute [rw] targets
  #   Names of targets with different configurations that can be exploited by this module.
  #
  #   @return [Array<Metasploit::Model::Module::Target>]

  # @!attribute [r] architectures
  #   The {Metasploit::Model::Architecture architectures} supported by this module.
  #
  #   @return [Array<Metasploit::Model::Architecture>]

  # @!attribute [r] authors
  #   The names of the authors of this module.
  #
  #   @return [Array<Metasploit::Model::Author>]

  # @!attribute [r] email_addresses
  #   The email addresses of the authors of this module.
  #
  #   @return [Array<Metasploit::Model::EmailAddress>]

  # @!attribute [r] platforms
  #   Platforms supported by this module.
  #
  #   @return [Array<Metasploit::Model::Module::Platform>]

  # @!attribute [r] references
  #   External references to the exploit or proof-of-concept (PoC) code in this module.
  #
  #   @return [Array<Metasploit::Model::Reference>]

  # @!attribute [r] vulns
  #   Vulnerabilities with same {Metasploit::Model::Reference reference} as this module.
  #
  #   @return [Array<Metasploit::Model::Vuln>]

  # @!attribute [r] vulnerable_hosts
  #   Hosts vulnerable to this module.
  #
  #   @return [Array<Metasploit::Model::Host>]

  # @!attribute [r] vulnerable_services
  #   Services vulnerable to this module.
  #
  #   @return [Array<Metasploit::Model::Service>]

  #
  # Attributes
  #

  # @!attribute [rw] description
  #   A long, paragraph description of what the module does.
  #
  #   @return [String]

  # @!attribute [rw] disclosed_on
  #   The date the vulnerability exploited by this module was disclosed to the public.
  #
  #   @return [Date, nil]

  # @!attribute [rw] license
  #   The name of the software license for the module's code.
  #
  #   @return [String]

  # @!attribute [rw] name
  #   The human readable name of the module.  It is unrelated to {Metasploit::Model::Module::Class#full_name} or
  #   {Metasploit::Model::Module::Class#reference_name} and is better thought of as a short summary of the
  #   {#description}.
  #
  #   @return [String]

  # @!attribute [rw] privileged
  #   Whether this module requires privileged access to run.
  #
  #   @return [Boolean]

  # @!attribute [rw] stance
  #   Whether the module is active or passive.  `nil` if the {#module_type} is not {#stanced?}.
  #
  #   @return ['active', 'passive', nil]

  #
  # Module Methods
  #

  module ClassMethods
    # Whether the given `:attribute` is allowed to be present for the given `:module_type`.  An attribute is
    # considered allowed if it allows greatrr than 0 elements for a collection.
    #
    # @raise [KeyError] if `:attribute` is not given in `options`.
    # @raise [KeyError] if `:module_type` is not given in `options`.
    # @return [true] if maximum elements is greater than 0 or value can be non-nil
    def allows?(options={})
      allowed = false
      length_validation_options = dynamic_length_validation_options(options)

      is = length_validation_options[:is]

      if is
        if is > 0
          allowed = true
        end
      else
        maximum = length_validation_options[:maximum]

        if maximum
          if maximum > 0
            allowed = true
          end
        else
          # if there is no maximum, then it's treated as infinite
          allowed = true
        end
      end

      allowed
    end

    # The length validation options for the given `:attribute` and `:module_type`.
    # @return [Hash{Symbol => Integer}] Hash containing either `:is` (meaning :maximum and :minimum are the same) or
    #   `:minimum` (no attribute has an explicit :maximum currently).
    # @raise [KeyError] if `:attribute` is not given in `options`.
    # @raise [KeyError] if `:module_type` is not given in `options`.
    # @raise [KeyError] if `:attribute` value is not a key in
    #   {DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE}.
    # @raise [KeyError] if `:module_type` value is a not a {Metasploit::Model::Module::Type::ALL} member.
    def dynamic_length_validation_options(options={})
      options.assert_valid_keys(:attribute, :module_type)
      attribute = options.fetch(:attribute)
      module_type = options.fetch(:module_type)

      dynamic_length_validation_options_by_module_type = DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE.fetch(attribute)
      dynamic_length_validation_options_by_module_type.fetch(module_type)
    end

    # Whether the `:module_type` requires stance to be in {Metasploit::Model::Module::Stance::ALL} or if it must
    # be `nil`.
    #
    # @param module_type [String] A member of `Metasploit::Model::Module::Type::ALL`.
    # @return [true] if `module_type` is in {STANCED_MODULE_TYPES}.
    # @return [false] otherwise.
    def stanced?(module_type)
      STANCED_MODULE_TYPES.include? module_type
    end
  end

  # make ClassMethods directly callable on Metasploit::Model::Module::Instance for factories
  extend ClassMethods

  #
  # Module Methods
  #

  # Values of {#module_type} (members of {Metasploit::Model::Module::Type::ALL}), which have an exact length
  # (`:is`) or maximum length (`:maximum`) greater than 0 for the given `attribute`.
  #
  # @return [Array<String>] Array with members of {Metasploit::Model::Module::Type::ALL}.
  # @see DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE
  def self.module_types_that_allow(attribute)
    dynamic_length_validation_options_by_module_type = DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE.fetch(attribute)

    dynamic_length_validation_options_by_module_type.each_with_object([]) { |(module_type, dynamic_length_validation_options), module_types|
      is = dynamic_length_validation_options[:is]

      if is
        if is > 0
          module_types << module_type
        end
      else
        maximum = dynamic_length_validation_options[:maximum]

        if maximum
          if maximum > 0
            module_types << module_type
          end
        else
          module_types << module_type
        end
      end

    }
  end

  #
  # Instance Methods
  #

  # Whether the given `attribute` is allowed to have elements.
  #
  # @param attribute [Symbol] name of attribute to check if {#module_type} allows it to have one or more
  #   elements.
  # @return (see Metasploit::Model::Module::Instance::ClassMethods#allows?)
  # @return [false] if {#module_type} is not valid
  def allows?(attribute)
    if Metasploit::Model::Module::Type::ALL.include? module_type
      self.class.allows?(
          attribute: attribute,
          module_type: module_type
      )
    else
      false
    end
  end

  # The dynamic length valdiations, such as `:is` and `:minimum` for the given attribute for the current
  # {#module_type}.
  #
  # @param attribute [Symbol] name of attribute whose dynamic length validation options to be
  # @return (see Metasploit::Model::Module::Instance::ClassMethods#dynamic_length_validation_options)
  # @return [{}] an empty Hash if {#module_type} is not a member of {Metasploit::Model::Module::Type::ALL}
  def dynamic_length_validation_options(attribute)
    if Metasploit::Model::Module::Type::ALL.include? module_type
      self.class.dynamic_length_validation_options(
          module_type: module_type,
          attribute: attribute
      )
    else
      {}
    end
  end

  # @!method module_type
  #   The {Metasploit::Model::Module::Class#module_type} of the {#module_class}.
  #
  #   @return (see Metasploit;:Model::Module::Class#module_type)
  delegate :module_type,
           allow_nil: true,
           to: :module_class

  # Whether {#module_type} requires {#stance} to be set or to be `nil`.
  #
  # @return (see Metasploit::Model::Module::Instance::ClassMethods#stanced?)
  # @return [false] if {#module_type} is not valid
  def stanced?
    self.class.stanced?(module_type)
  end

  private

  # Validates that the {#module_architectures}
  # {Metasploit::Model::Module::Architecture#architecture architectures} match the {#targets}
  # {Metasploit::Model::Module::Target#target_architectures target_architectures}
  # {Metasploit::Model::Module::Target::Architecture#architecture architectures}.
  #
  # @return [void]
  def architectures_from_targets
    actual_architecture_set = Set.new module_architectures.map(&:architecture)
    expected_architecture_set = Set.new

    targets.each do |module_target|
      module_target.target_architectures.each do |target_architecture|
        expected_architecture_set.add target_architecture.architecture
      end
    end

    extra_architecture_set = actual_architecture_set - expected_architecture_set

    unless extra_architecture_set.empty?
      human_extra_architectures = human_architecture_set(extra_architecture_set)

      errors.add(:architectures, :extra, extra: human_extra_architectures)
    end

    missing_architecture_set = expected_architecture_set - actual_architecture_set

    unless missing_architecture_set.empty?
      human_missing_architectures = human_architecture_set(missing_architecture_set)

      errors.add(:architectures, :missing, missing: human_missing_architectures)
    end
  end

  # Converts a Set<Metasploit::Model::Architecture> to a human readable representation including the
  # {Metasploit::Model::Architecture#abbreviation}.
  #
  # @return [String]
  def human_architecture_set(architecture_set)
    abbreviations = architecture_set.map(&:abbreviation)

    human_set(abbreviations)
  end

  # Converts a Set<Metasploit::Model::Platform> to a human-readable representation including the
  # {Metasploit::Model::Platform#fully_qualified_name}.
  #
  # @return [String]
  def human_platform_set(platform_set)
    fully_qualified_names = platform_set.map(&:fully_qualified_name)

    human_set(fully_qualified_names)
  end

  # Converts strings to a human-readable set notation.
  #
  # @return [String]
  def human_set(strings)
    sorted = strings.sort
    comma_separated = sorted.join(', ')

    "{#{comma_separated}}"
  end

  # Validates that {#module_platforms} {Metasploit::Model::Module::Platform#platform platforms} match the
  # {#targets} {Metasploit::Model::Module::Target#target_platforms target_platforms}
  # {Metasploit::Model::Module::Target::Platform#platform platforms}.
  #
  # @return [void]
  def platforms_from_targets
    actual_platform_set = Set.new module_platforms.map(&:platform)
    expected_platform_set = Set.new

    targets.each do |module_target|
      module_target.target_platforms.each do |target_platform|
        expected_platform_set.add target_platform.platform
      end
    end

    extra_platform_set = actual_platform_set - expected_platform_set

    unless extra_platform_set.empty?
      human_extra_platforms = human_platform_set(extra_platform_set)

      errors.add(:platforms, :extra, extra: human_extra_platforms)
    end

    missing_platform_set = expected_platform_set - actual_platform_set

    unless missing_platform_set.empty?
      human_missing_platforms = human_platform_set(missing_platform_set)

      errors.add(:platforms, :missing, missing: human_missing_platforms)
    end
  end
end
