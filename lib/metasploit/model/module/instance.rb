module Metasploit
  module Model
    module Module
      # Code shared between `Mdm::Module::Instance` and `Metasploit::Framework::Module::Instance`.
      module Instance
        extend ActiveModel::Naming
        extend ActiveSupport::Concern

        include Metasploit::Model::Translation

        #
        # CONSTANTS
        #

        # Minimum length of {#module_authors}.
        MINIMUM_MODULE_AUTHORS_LENGTH = 1

        # {#privileged} is Boolean so, valid values are just `true` and `false`, but since both the validation and
        # factory need an array of valid values, this constant exists.
        PRIVILEGES = [
            false,
            true
        ]

        # Maps attribute to map of {Metasploit::Model::Module::Class#module_type} maps to whether that attribute is
        # supported.  Supported attributes should be present, while unsupported attributes should be blank in
        # validations.
        SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE = {
            actions: {
                Metasploit::Model::Module::Type::AUX => true,
                Metasploit::Model::Module::Type::ENCODER => false,
                Metasploit::Model::Module::Type::EXPLOIT => false,
                Metasploit::Model::Module::Type::NOP => false,
                Metasploit::Model::Module::Type::PAYLOAD => false,
                Metasploit::Model::Module::Type::POST => false
            },
            module_architectures: {
                Metasploit::Model::Module::Type::AUX => false,
                Metasploit::Model::Module::Type::ENCODER => true,
                Metasploit::Model::Module::Type::EXPLOIT => true,
                Metasploit::Model::Module::Type::NOP => true,
                Metasploit::Model::Module::Type::PAYLOAD => true,
                Metasploit::Model::Module::Type::POST => true
            },
            module_platforms: {
                Metasploit::Model::Module::Type::AUX => false,
                Metasploit::Model::Module::Type::ENCODER => false,
                Metasploit::Model::Module::Type::EXPLOIT => true,
                Metasploit::Model::Module::Type::NOP => false,
                Metasploit::Model::Module::Type::PAYLOAD => true,
                Metasploit::Model::Module::Type::POST => true
            },
            module_references: {
                Metasploit::Model::Module::Type::AUX => true,
                Metasploit::Model::Module::Type::ENCODER => false,
                Metasploit::Model::Module::Type::EXPLOIT => true,
                Metasploit::Model::Module::Type::NOP => false,
                Metasploit::Model::Module::Type::PAYLOAD => false,
                Metasploit::Model::Module::Type::POST => true
            },
            stance: {
                Metasploit::Model::Module::Type::AUX => true,
                Metasploit::Model::Module::Type::ENCODER => false,
                Metasploit::Model::Module::Type::EXPLOIT => true,
                Metasploit::Model::Module::Type::NOP => false,
                Metasploit::Model::Module::Type::PAYLOAD => false,
                Metasploit::Model::Module::Type::POST => false
            },
            targets: {
                Metasploit::Model::Module::Type::AUX => false,
                Metasploit::Model::Module::Type::ENCODER => false,
                Metasploit::Model::Module::Type::EXPLOIT => true,
                Metasploit::Model::Module::Type::NOP => false,
                Metasploit::Model::Module::Type::PAYLOAD => false,
                Metasploit::Model::Module::Type::POST => false
            }
        }

        included do
          include ActiveModel::Validations
          include Metasploit::Model::Search
          extend Metasploit::Model::Translation

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
          # Validations
          #

          validates :actions,
                    support: true
          validates :description,
                    :presence => true
          validates :license,
                    :presence => true
          validates :module_architectures,
                    support: true
          validates :module_authors,
                    :length => {
                        :minimum => MINIMUM_MODULE_AUTHORS_LENGTH
                    }
          validates :module_class,
                    :presence => true
          validates :module_platforms,
                    support: true
          validates :module_references,
                    support: true
          validates :name,
                    :presence => true
          validates :privileged,
                    :inclusion => {
                        :in => PRIVILEGES
                    }
          validates :stance,
                    inclusion: {
                        if: 'supports?(:stance)',
                        in: Metasploit::Model::Module::Stance::ALL
                    }
          validates :targets,
                    support: true
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

        # @!attribute [rw] module_authors
        #   Joins this with {#authors} and {#email_addresses} to model the name and email address used for an author
        #   entry in the module metadata.
        #
        #   @return [Array<Metasploit::Model::Module::Author>]

        # @!attribute [rw] module_class
        #   Class-derived metadata to go along with the instance-derived metadata in this model.
        #
        #   @return [Metasploit::Model::Module::Class]

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
        #   Whether the module is active or passive.  `nil` if the
        #   {Metasploit::Model::Module::Class#module_type module type} does not {#supports? support stances}.
        #
        #   @return ['active', 'passive', nil]

        #
        # Module Methods
        #

        # @note This is not declared in `ClassMethods` because it is to support factories that only know about
        #   {Metasploit::Model::Module::Instance}.
        #
        # Whether the {Metasploit::Model::Module::Class#module_type} supports the given `attribute` on
        # its module instances.
        #
        # @return [false] The given `attribute` is not supported and the `attribute` value should be blank, `nil` for
        #   single values and empty for collections.
        # @return [true] The given 'attribute' is supported and the `attribute` value should be present, non-nil for
        #   single values and at least one element for collections.
        # @raise [KeyError] if `attribute` is not an attributes whose support varies based on
        #   {Metasploit::Model::Module::Class#module_type}.
        # @raise [KeyError] if {#module_class} {Metasploit::Model::Module::Class#module_type} is invalid.
        def self.module_type_supports?(module_type, attribute)
          support_by_module_type = SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE.fetch(attribute)
          support_by_module_type.fetch(module_type)
        end

        #
        # Instance Methods
        #

        # Whether the {#module_class} {Metasploit::Model::Module::Class#module_type} supports the given `attribute` on
        # its module instances.
        #
        # @return [false] The given `attribute` is not supported and the `attribute` value should be blank, `nil` for
        #   single values and empty for collections.  May also be false if {#module_class} is `nil` or {#module_class}'s
        #   {Metasploit::Model::Module::Class#module_type} is invalid.
        # @return [true] The given 'attribute' is supported and the `attribute` value should be present, non-nil for
        #   single values and at least one element for collections.
        # @raise [KeyError] if `attribute` is not an attributes whose support varies based on
        #   {Metasploit::Model::Module::Class#module_type}.
        def supports?(attribute)
          supported = false
          support_by_module_type = SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE.fetch(attribute)

          # unlike attribute, which is controlled by the developer, the module_class and module_type is controlled by
          # the user and so can be invalid and not have a value in `support_by_module_type` and so can't be fetched and
          # must be handled cleanly without exceptions.
          if module_class
            # default to false when module_type is a unknown type, to match behavior when module_class is nil.
            supported = support_by_module_type.fetch(module_class.module_type, supported)
          end

          supported
        end
      end
    end
  end
end

