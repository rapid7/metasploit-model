module Metasploit
  module Model
    module Module
      # Code shared between `Mdm::Module::Target` and `Metasploit::Framework::Module::Target`.
      module Target
        extend ActiveModel::Naming
        extend ActiveSupport::Concern

        include Metasploit::Model::Translation

        included do
          include ActiveModel::MassAssignmentSecurity
          include ActiveModel::Validations
          include Metasploit::Model::Search

          #
          # Mass Assignment Security
          #

          attr_accessible :index
          attr_accessible :name

          #
          # Search Attributes
          #

          search_attribute :name, :type => :string

          #
          # Validators
          #

          validates :index, :presence => true
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

        # @!attribute [rw] index
        #   Index of this target among other {Metasploit::Model::Module::Instance#targets targets} for
        #   {#module_instance}.  The default target is usually specified by index in the module code, so the indices for
        #   targets is mirror here for easier correlation.  The default target is an
        #   {Metasploit::Model::Module::Instance#default_target association} on {Metasploit::Model::Module::Instance},
        #   not an index like in the code for easier reporting and searching.
        #
        #   @return [Integer]

        # @!attribute [rw] name
        #   The name of this target.
        #
        #   @return [String]
      end
    end
  end
end
