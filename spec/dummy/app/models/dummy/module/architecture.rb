class Dummy::Module::Architecture < Metasploit::Model::Base
  include Metasploit::Model::Module::Architecture

  #
  # Attributes
  #

  # @!attribute [rw] architecture
  #   The architecture supported by the {#module_instance}.
  #
  #   @return [Metasploit::Model::Architecture]
  attr_accessor :architecture

  # @!attribute [rw] module_instance
  #   The module instance that supports {#architecture}.
  #
  #   @return [Metasploit::Model::Module::Instance]
  attr_accessor :module_instance
end