class Dummy::Module::Target::Platform < Metasploit::Model::Base
  include Metasploit::Model::Module::Target::Platform

  #
  # Associations
  #

  # @!attribute [rw] module_target
  #   The module target that supports {#platform}.
  #
  #   @return [Dummy::Module::Target]
  attr_accessor :module_target

  # @!attribute [rw] platform
  #   The platform supported by the {#module_target}.
  #
  #   @return [Dummy::Platform]
  attr_accessor :platform
end