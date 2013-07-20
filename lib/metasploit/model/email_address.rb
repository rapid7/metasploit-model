module Metasploit
  module Model
    # Code shared between `Mdm::EmailAddress` and `Metasploit::Framework::EmailAddress`.
    module EmailAddress
      extend ActiveSupport::Concern

      included do
        include ActiveModel::MassAssignmentSecurity
        include ActiveModel::Validations

        #
        # Mass Assignment Security
        #

        attr_accessible :domain
        attr_accessible :local

        #
        # Validations
        #

        validates :domain, :presence => true
        validates :local, :presence => true
      end

      #
      # Associations
      #

      # @!attribute [rw] module_authors
      #   Credits where {#authors} used this email address for {#module_instances modules}.
      #
      #   @return [Array<Metasploit::Model::Module::Author>]

      # @!attribute [r] authors
      #   Authors that used this email address.
      #
      #   @return [Array<Metasploit::Model::Author>]

      # @!attribute [r] module_instances
      #   Modules where this email address was used.
      #
      #   @return [Array<Metasploit::Module::Instance>]

      #
      # Attributes
      #

      # @!attribute [rw] domain
      #   The domain part of the email address after the `'@'`.
      #
      #   @return [String]

      # @!attribute [rw] local
      #   The local part of the email address before the `'@'`.
      #
      #   @return [String]
    end
  end
end