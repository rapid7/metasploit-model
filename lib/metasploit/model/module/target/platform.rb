require 'metasploit/model/translation'

module Metasploit
  module Model
    module Module
      module Target
        # Model that joins {Metasploit::Model::Platform} and {Metasploit::Model::Module::Target}.
        module Platform
          extend ActiveModel::Naming
          extend ActiveSupport::Concern

          include Metasploit::Model::Translation

          included do
            include ActiveModel::Validations

            #
            # Validations
            #

            validates :module_target,
                      presence: true
            validates :platform,
                      presence: true
          end

          #
          # Associations
          #

          # @!attribute [rw] module_target
          #   The module target that supports {#platform}.
          #
          #   @return [Metasploit::Model::Module::Target]

          # @!attribute [rw] platform
          #   The platform supported by the {#module_target}.
          #
          #   @return [Metasploit::Model::Platform]
        end
      end
    end
  end
end