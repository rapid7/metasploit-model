module Metasploit
  module Model
    module Module
      # Code shared between `Mdm::Module::Instance` and `Metasploit::Framework::Module::Instance`.
      module Instance
        extend ActiveSupport::Concern
        extend Metasploit::Model::Search::Translation

        #
        # CONSTANTS
        #

        # {#privileged} is Boolean so, valid values are just `true` and `false`, but since both the validation and
        # factory need an array of valid values, this constant exists.
        PRIVILEGES = [
            false,
            true
        ]

        # {Metasploit::Model::Module::Class#module_type Module types} that {#supports_stance? support stance}.
        STANCED_MODULE_TYPES = [
            Metasploit::Model::Module::Type::AUX,
            Metasploit::Model::Module::Type::EXPLOIT
        ]

        # Valid values for {#stance}.
        STANCES = [
            'aggressive',
            'passive'
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
          # Validations
          #

          validates :module_class,
                    :presence => true
          validates :privileged,
                    :inclusion => {
                        :in => PRIVILEGES
                    }
          validates :stance,
                    :inclusion => {
                        :if => :supports_stance?,
                        :in => STANCES
                    }
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
        #   {Metasploit::Model::Module::Class#module_type module type} does not {#supports_stance? support stances}.
        #
        #   @return ['active', 'passive', nil]

        #
        # Instance Methods
        #

        # Returns whether this module supports a {#stance}.  Only modules with
        # {Metasploit::Model::Module::Class#module_type} `'auxiliary'` and `'exploit'` support a non-nil {#stance}.
        #
        # @return [true] if {Metasploit::Model::Module::Class#module_type module_class.module_type} is `'auxiliary'` or
        #   `'exploit'`
        # @return [false] otherwise
        # @see https://github.com/rapid7/metasploit-framework/blob/a6070f8584ad9e48918b18c7e765d85f549cb7fd/lib/msf/core/db_manager.rb#L423
        # @see https://github.com/rapid7/metasploit-framework/blob/a6070f8584ad9e48918b18c7e765d85f549cb7fd/lib/msf/core/db_manager.rb#L436
        def supports_stance?
          supports_stance = false

          if module_class and STANCED_MODULE_TYPES.include?(module_class.module_type)
            supports_stance = true
          end

          supports_stance
        end
      end
    end
  end
end

