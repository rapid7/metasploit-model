FactoryGirl.define do
  module_references_module_types = Metasploit::Model::Module::Instance.module_types_that_allow(:module_references)

  sequence :metasploit_model_module_reference_module_type, module_references_module_types.cycle

  trait :metasploit_model_module_reference do
    ignore do
      module_type { generate :metasploit_model_module_reference_module_type }
    end
  end
end