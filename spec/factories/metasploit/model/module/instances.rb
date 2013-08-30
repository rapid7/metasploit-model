FactoryGirl.define do
  sequence :metasploit_model_module_instance_description do |n|
    "Module Description #{n}"
  end

  sequence :metasploit_model_module_instance_disclosed_on do |n|
    Date.today - n
  end

  sequence :metasploit_model_module_instance_license do |n|
    "Module License #{n}"
  end

  sequence :metasploit_model_module_instance_stanced_module_type, Metasploit::Model::Module::Instance::STANCED_MODULE_TYPES.cycle

  sequence :metasploit_model_module_instance_name do |n|
    "Module Name #{n}"
  end

  sequence :metasploit_model_module_instance_privileged, Metasploit::Model::Module::Instance::PRIVILEGES.cycle

  sequence :metasploit_model_module_instance_stance, Metasploit::Model::Module::Instance::STANCES.cycle

  trait :metasploit_model_module_instance do
    #
    # Attributes
    #

    description { generate :metasploit_model_module_instance_description }
    disclosed_on { generate :metasploit_model_module_instance_disclosed_on }
    license { generate :metasploit_model_module_instance_license }
    name { generate :metasploit_model_module_instance_name }
    privileged { generate :metasploit_model_module_instance_privileged }
  end
end