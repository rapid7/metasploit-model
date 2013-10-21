FactoryGirl.define do
  module_platforms_support_by_module_type = Metasploit::Model::Module::Instance::SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE.fetch(:module_platforms)
  metasploit_model_module_platform_module_types = module_platforms_support_by_module_type.each_with_object([]) { |pair, metasploit_model_module_platform_module_types|
    module_type, support = pair

    if support
      metasploit_model_module_platform_module_types << module_type
    end
  }

  sequence :metasploit_model_module_platform_module_type, metasploit_model_module_platform_module_types.cycle

  trait :metasploit_model_module_platform do
    ignore do
      module_type { generate :metasploit_model_module_platform_module_type }
    end
  end
end