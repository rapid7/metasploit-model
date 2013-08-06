FactoryGirl.define do
  factory :dummy_module_target,
          :class => Dummy::Module::Target,
          :traits => [
              :metasploit_model_module_target
          ] do
    #
    # Associations
    #

    association :module_instance, :factory => :dummy_module_instance
  end
end