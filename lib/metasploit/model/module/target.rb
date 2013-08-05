module Metasploit
  module Model
    module Module
      # Code shared between `Mdm::Module::Target` and `Metasploit::Framework::Module::Target`.
      module Target
        extend ActiveSupport::Concern

        included do
          include ActiveModel::MassAssignmentSecurity
          include ActiveModel::Validations

          #
          # Mass Assignment Security
          #

          attr_accessible :index
          attr_accessible :name

          #
          # Validators
          #

          validates :index, :presence => true
          validates :module_instance, :presence => true
          validates :name, :presence => true
        end

        #
        # Associations
        #

        # @!attribute [rw] module_instance
        #   Module where this target was declared.
        #
        #   @return [Metasploit::Model::Module::Instance]

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
