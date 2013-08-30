module Metasploit
  module Model
    # Code shared between `Mdm::Platform` and `Metasploit::Framework::Platform`.
    module Platform
      extend ActiveSupport::Concern
      extend Metasploit::Model::Search::Translation

      included do
        include ActiveModel::Validations
        include Metasploit::Model::Search

        #
        # Search
        #

        search_attribute :name, :type => :string

        #
        # Validation
        #

        validates :name,
                  :presence => true
      end

      #
      # Attributes
      #

      # @!attribute [rw] name
      #   The name of the platform
      #
      #   @return [String]
    end
  end
end