module Metasploit
  module Model
    module Module
      # Code shared between `Mdm::Module::Ancestor` and `Metasploit::Framework::Module::Ancestor`.
      module Ancestor
        #
        # CONSTANTS
        #

        # The directory for a given #module_type is a not always the pluralization of #module_type, so this maps the
        # #module_type to the type directory that is used to generate the #real_path from the #module_type and
        # #reference_name.
        DIRECTORY_BY_MODULE_TYPE = {
            'auxiliary' => 'auxiliary',
            'encoder' => 'encoders',
            'exploit' => 'exploits',
            'nop' => 'nops',
            'payload' => 'payloads',
            'post' => 'post'
        }

        # The modules types from {DIRECTORY_BY_MODULE_TYPE}.
        MODULE_TYPES = DIRECTORY_BY_MODULE_TYPE.keys.sort
      end
    end
  end
end