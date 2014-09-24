# Code shared between `Mdm::Module::Target` and `Metasploit::Framework::Module::Target`.
module Metasploit::Model::Module::Target
  extend ActiveModel::Naming
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  include Metasploit::Model::Translation

  autoload :Architecture
  autoload :Platform

  included do
    include ActiveModel::MassAssignmentSecurity
    include ActiveModel::Validations
    include Metasploit::Model::Search

    #
    # Mass Assignment Security
    #

    attr_accessible :name

    #
    # Search Attributes
    #

    search_attribute :name, :type => :string

    #
    # Validators
    #

    validates :module_instance, :presence => true
    validates :name, :presence => true
    validates :target_architectures, presence: true
    validates :target_platforms, presence: true
  end

  #
  # Associations
  #

  # @!attribute [r] architectures
  #   Architectures that this target supports, either by being declared specifically for this target or because
  #   this target did not override architectures and so inheritted the architecture set from the class.
  #
  #   @return [Array<Metasploit::Model::Architecture>]

  # @!attribute [rw] module_instance
  #   Module where this target was declared.
  #
  #   @return [Metasploit::Model::Module::Instance]

  # @!attribute [r] platforms
  #   Platforms that this target supports, either by being declared specifically for this target or because this
  #   target did not override platforms and so inheritted the platform set from the class.
  #
  #   @return [Array<Metasploit::Model::Platform>]

  # @!attribute [rw] target_architectures
  #   Joins this target to its {#architectures}
  #
  #   @return [Array<Metasploit::Model::Module::Target::Architecture]

  # @!attribute [rw] target_platforms
  #   Joins this target to its {#platforms}
  #
  #   @return [Array<Metasploit::Model::Module::Target::Platform>]

  #
  # Attributes
  #

  # @!attribute [rw] name
  #   The name of this target.
  #
  #   @return [String]
end
