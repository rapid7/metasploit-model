FactoryGirl.define do
  module_architectures_support_by_module_type = Metasploit::Model::Module::Instance::SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE.fetch(:module_architectures)
  metasploit_model_module_architecture_module_types = module_architectures_support_by_module_type.each_with_object([]) { |pair, metasploit_model_module_architecture_module_types|
    module_type, support = pair

    if support
      metasploit_model_module_architecture_module_types << module_type
    end
  }

  sequence :metasploit_model_module_architecture_module_type, metasploit_model_module_architecture_module_types.cycle

  trait :metasploit_model_module_architecture do
    ignore do
      module_type { generate :metasploit_model_module_architecture_module_type }
    end
  end
end