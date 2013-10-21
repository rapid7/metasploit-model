FactoryGirl.define do
  factory :dummy_module_reference,
          class: Dummy::Module::Reference,
          traits: [
              :metasploit_model_base,
              :metasploit_model_module_reference
          ] do
    ignore do
      # have to use module_type from metasploit_model_module_reference trait to ensure module_instance will support
      # module references.
      module_class { FactoryGirl.create(:dummy_module_class, module_type: module_type) }
    end

    module_instance { FactoryGirl.create(:dummy_module_instance, module_class: module_class) }
    association :reference, factory: :dummy_reference
  end
end