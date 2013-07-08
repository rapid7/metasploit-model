module Metasploit
  module Model
    module Module
      # Code shared between `Mdm::Module::Ancestor` and `Metasploit::Framework::Module::Ancestor`.
      module Ancestor
        #
        # CONSTANTS
        #

        # Module types
        MODULE_TYPES = [
            'auxiliary',
            'encoder',
            'exploit',
            'nop',
            'payload',
            'post'
        ]
      end
    end
  end
end