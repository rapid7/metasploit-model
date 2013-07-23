module Metasploit
  module Model
    # Code shared between `Mdm::Platform` and `Metasploit::Framework::Platform`.
    module Platform
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Validations

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