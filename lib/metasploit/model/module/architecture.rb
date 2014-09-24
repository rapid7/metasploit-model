# Model that joins {Metasploit::Model::Architecture} and {Metasploit::Model::Module::Instance}.
module Metasploit::Model::Module::Architecture
  extend ActiveModel::Naming
  extend ActiveSupport::Concern

  include Metasploit::Model::Translation

  included do
    include ActiveModel::Validations

    #
    # Validations
    #

    validates :architecture,
              :presence => true
    validates :module_instance,
              :presence => true
  end

  #
  # Attributes
  #

  # @!attribute [rw] architecture
  #   The architecture supported by the {#module_instance}.
  #
  #   @return [Metasploit::Model::Architecture]

  # @!attribute [rw] module_instance
  #   The module instance that supports {#architecture}.
  #
  #   @return [Metasploit::Model::Module::Instance]
end
