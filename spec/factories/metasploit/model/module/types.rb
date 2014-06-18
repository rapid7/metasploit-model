FactoryGirl.define do
  sequence :metasploit_model_module_type, Metasploit::Model::Module::Type::ALL.cycle

  sequence :metasploit_model_non_payload_module_type, Metasploit::Model::Module::Type::NON_PAYLOAD.cycle
end