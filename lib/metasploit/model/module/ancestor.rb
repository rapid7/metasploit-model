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
            Metasploit::Model::Module::Type::AUX => Metasploit::Model::Module::Type::AUX,
            Metasploit::Model::Module::Type::ENCODER => Metasploit::Model::Module::Type::ENCODER.pluralize,
            Metasploit::Model::Module::Type::EXPLOIT => Metasploit::Model::Module::Type::EXPLOIT.pluralize,
            Metasploit::Model::Module::Type::NOP => Metasploit::Model::Module::Type::NOP.pluralize,
            Metasploit::Model::Module::Type::PAYLOAD => Metasploit::Model::Module::Type::PAYLOAD.pluralize,
            Metasploit::Model::Module::Type::POST => Metasploit::Model::Module::Type::POST
        }
      end
    end
  end
end