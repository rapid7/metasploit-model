FactoryGirl.define do
  sequence :metasploit_model_module_type, Metasploit::Model::Module::Type::ALL.cycle

  non_payload_module_types = Metasploit::Model::Module::Type::ALL - [Metasploit::Model::Module::Type::PAYLOAD]
  sequence :metasploit_model_non_payload_module_type, non_payload_module_types.cycle
end