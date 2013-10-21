class Dummy::Module::Reference < Metasploit::Model::Base
  include Metasploit::Model::Module::Reference

  #
  # Associations
  #

  # @!attribute [rw] module_instance
  #   {Dummy::Module::Instance Module} with {#reference}.
  #
  #   @return [Dummy::Module::Instance]
  attr_accessor :module_instance

  # @!attribute [rw] reference
  #   {Dummy::Reference reference} to exploit or proof-of-concept (PoC) code for {#module_instance}.
  #
  #   @return [Dummy::Reference]
  attr_accessor :reference
end