FactoryGirl.define do
  factory :dummy_module_action,
          :class => Dummy::Module::Action,
          :traits => [
              :metasploit_model_module_action
          ] do
    #
    # Associations
    #

    association :module_instance, :factory => :dummy_module_instance
  end
end