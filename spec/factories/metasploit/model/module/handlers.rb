FactoryGirl.define do
  sequence :metasploit_model_module_handler_general_type, Metasploit::Model::Module::Handler::GENERAL_TYPES.cycle

  sequence :metasploit_model_module_handler_type do |n|
    "metasploit_model_module_handler_type#{n}"
  end
end