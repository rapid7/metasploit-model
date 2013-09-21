module Metasploit
  module Model
    module Module
      # The handler Module for a {Metasploit::Model::Module::Ancestor#handled?} {Metasploit::Model::Module::Ancestor}.
      module Handler
        #
        # CONSTANTS
        #

        # General handler types that are used as connection types for Msf::Payloads.
        GENERAL_TYPES = [
            'bind',
            'find',
            'none',
            'reverse',
            'tunnel'
        ]
      end
    end
  end
end