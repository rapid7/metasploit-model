FactoryGirl.define do
  sequence :metasploit_model_module_action_name do |n|
    "Metasploit::Model::Module::Action#name #{n}"
  end

  trait :metasploit_model_module_action do
    name { generate :metasploit_model_module_action_name }
  end
end