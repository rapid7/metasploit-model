module Metasploit
  module Model
    module Module
      # Code shared between `Mdm::Module::Action` and `Metasploit::Framework::Module::Action`.
      module Action
        extend ActiveSupport::Concern
        extend Metasploit::Model::Search::Translation

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

          validates :module_instance,
                    :presence => true
          validates :name,
                    :presence => true
        end

        #
        # Associations
        #

        # @!attribute [rw] module_instance
        #   Module that has this action.
        #
        #   @return [Metasploit::Model::Module::Instance]

        #
        # Attributes
        #

        # @!attribute [rw] name
        #   The name of this action.
        #
        #   @return [String]
      end
    end
  end
end
