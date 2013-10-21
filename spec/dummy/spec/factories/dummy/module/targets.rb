FactoryGirl.define do
  factory :dummy_module_target,
          :class => Dummy::Module::Target,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_module_target
          ] do
    ignore do
      # have to use module_type from metasploit_model_module_target trait to ensure module_instance will support
      # module targets.
      module_class { FactoryGirl.create(:dummy_module_class, module_type: module_type) }
    end

    module_instance { FactoryGirl.create(:dummy_module_instance, module_class: module_class) }
  end
end