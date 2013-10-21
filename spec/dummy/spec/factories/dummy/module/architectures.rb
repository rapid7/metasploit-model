FactoryGirl.define do
  factory :dummy_module_architecture,
          class: Dummy::Module::Architecture,
          traits: [
              :metasploit_model_base,
              :metasploit_model_module_architecture
          ] do
    ignore do
      # have to use module_type from metasploit_model_module_architecture trait to ensure module_instance will support
      # module architectures.
      module_class { FactoryGirl.create(:dummy_module_class, module_type: module_type) }
    end

    architecture { generate :dummy_architecture }
    module_instance { FactoryGirl.create(:dummy_module_instance, module_class: module_class) }
  end
end