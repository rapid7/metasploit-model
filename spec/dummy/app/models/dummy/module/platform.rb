class Dummy::Module::Platform < Metasploit::Model::Base
  include Metasploit::Model::Module::Platform

  #
  # Associations
  #

  # @!attribute [rw] module_instance
  #   Module that supports {#platform}.
  #
  #   @return [Dummy::Module::Instance]
  attr_accessor :module_instance

  # @!attribute [rw] platform
  #  Platform supported by {#module_instance}.
  #
  #  @return [Dummy::Platform]
  attr_accessor :platform
end