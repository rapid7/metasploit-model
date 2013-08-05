FactoryGirl.define do
  sequence :metasploit_model_module_target_index do |n|
    n
  end

  sequence :metasploit_model_module_target_name do |n|
    "Metasploit::Model::Module::Target#name #{n}"
  end

  trait :metasploit_model_module_target do
    index { generate :metasploit_model_module_target_index }
    name { generate :metasploit_model_module_target_name }
  end
end