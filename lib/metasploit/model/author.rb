require 'metasploit/model/translation'

module Metasploit
  module Model
    # Code shared between `Mdm::Author` and `Metasploit::Framework::Author`.
    module Author
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

        attr_accessible :name

        #
        # Search Attributes
        #

        search_attribute :name, :type => :string

        #
        # Validations
        #

        validates :name, :presence => true
      end

      #
      # Associations
      #

      # @!attribute [r] email_addresses
      #   Email addresses used by this author across all {#module_instances}.
      #
      #   @return [Array<Metasploit::Model::EmailAddress>]

      # @!attribute [r] module_instances
      #   Modules written by this author.
      #
      #   @return [Array<Metasploit::Model::Module::Instance>]

      #
      # Attributes
      #

      # @!attribute [rw] name
      #   Full name (First + Last name) or handle of author.
      #
      #   @return [String]
    end
  end
end