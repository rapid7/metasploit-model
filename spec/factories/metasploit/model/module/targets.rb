FactoryGirl.define do
  total_architectures = Metasploit::Model::Architecture::ABBREVIATIONS.length
  total_platforms = Metasploit::Model::Platform.fully_qualified_name_set.length
  targets_module_types = Metasploit::Model::Module::Instance.module_types_that_allow(:targets)

  sequence :metasploit_model_module_target_module_type, targets_module_types.cycle

  sequence :metasploit_model_module_target_name do |n|
    "Metasploit::Model::Module::Target#name #{n}"
  end

  trait :metasploit_model_module_target do
    ignore do
      module_type { generate :metasploit_model_module_target_module_type }

      target_architectures_length { Random.rand(1 .. total_architectures) }
      target_platforms_length { Random.rand(1 .. total_platforms) }
    end

    name { generate :metasploit_model_module_target_name }
  end
end