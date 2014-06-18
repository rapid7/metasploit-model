# Child of a {Metasploit::Model::Configuration} that contains a reference to the {#configuration}.
class Metasploit::Model::Configuration::Child
  #
  # Attributes
  #

  # @!attribute [rw] configuration
  #   Main configuration.
  #
  #   @return [Metasploit::Model::Configuration::Autoload]
  attr_accessor :configuration
end