module Metasploit
  module Model
    module Module
      # Defines constants for {Metasploit::Model::Module} types as used in {Metasploit::Model::Module::Ancestor}.
      module Type
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
      end
    end
  end
end