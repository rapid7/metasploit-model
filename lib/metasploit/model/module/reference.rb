# Joins {Metasploit::Model::Module::Instance} and {Metasploit::Model::Reference}.
module Metasploit::Model::Module::Reference
  extend ActiveModel::Naming
  extend ActiveSupport::Concern

  include Metasploit::Model::Translation

  included do
    include ActiveModel::Validations

    #
    # Validations
    #

    validates :module_instance, :presence => true
    validates :reference, :presence => true
  end

  #
  # Associations
  #

  # @!attribute [rw] module_instance
  #   {Metasploit::Model::Module::Instance Module} with {#reference}.
  #
  #   @return [Metasploit::Model::Module::Instance]

  # @!attribute [rw] reference
  #   {Metasploit::Model::Reference reference} to exploit or proof-of-concept (PoC) code for {#module_instance}.
  #
  #   @return [Metasploit::Model::Reference]
end
