FactoryGirl.define do
  module_platforms_module_types = Metasploit::Model::Module::Instance.module_types_that_allow(:module_platforms)
  targets_module_types = Metasploit::Model::Module::Instance.module_types_that_allow(:targets)

  # have to remove target supporting types so that target platforms won't interfere with module platforms
  metasploit_model_module_platform_module_types = module_platforms_module_types - targets_module_types

  sequence :metasploit_model_module_platform_module_type, metasploit_model_module_platform_module_types.cycle

  trait :metasploit_model_module_platform do
    ignore do
      module_type { generate :metasploit_model_module_platform_module_type }
    end
  end
end