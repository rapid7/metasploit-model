class Dummy::Module::Target::Architecture < Metasploit::Model::Base
  include Metasploit::Model::Module::Target::Architecture

  #
  # Associations
  #

  # @!attribute [rw] architecture
  #   The architecture supported by the {#module_target}.
  #
  #   @return [Dummy::Architecture]
  attr_accessor :architecture

  # @!attribute [rw] module_target
  #   The module target that supports {#architecture}.
  #
  #   @return [Dummy::Module::Target]
  attr_accessor :module_target
end