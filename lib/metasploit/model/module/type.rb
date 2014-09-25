# Defines constants for {Metasploit::Model::Module} types as used in {Metasploit::Model::Module::Ancestor}.
module Metasploit::Model::Module::Type
  #
  # CONSTANTS
  #

  # Symbolizes any module type is allowed.
  ANY = '_any_'
  # Auxiliary modules
  AUX = 'auxiliary'
  # Encoder modules
  ENCODER = 'encoder'
  # Exploit modules
  EXPLOIT = 'exploit'
  # No operation modules
  NOP = 'nop'
  # Payload modules
  PAYLOAD = 'payload'
  # Post-exploitation modules
  POST = 'post'

  # Array<String> of all supported module types (except {ANY} since that's a symbolic type)
  ALL = [
      AUX,
      ENCODER,
      EXPLOIT,
      NOP,
      PAYLOAD,
      POST
  ]

  # Array<String> of all module types that aren't {PAYLOAD} because {PAYLOAD}
  # {Metasploit::Model::Module::Ancestor#contents} define `Modules` instead of `Classes` and so need to be loaded
  # differently.
  NON_PAYLOAD = ALL.reject { |module_type|
    module_type == PAYLOAD
  }
end
