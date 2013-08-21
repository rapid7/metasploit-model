FactoryGirl.define do
  factory :dummy_module_instance,
          :class => Dummy::Module::Instance,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_module_instance
          ] do
    #
    # Associations
    #

    association :module_class, :factory => :dummy_module_class

    # attribute must be called after association is created so that support_stance? has access to module_class
    # needs to be declared explicitly after association as calling trait here (instead as an argument to factory
    # :traits) did not work.
    stance {
      if supports_stance?
        generate :metasploit_model_module_instance_stance
      else
        nil
      end
    }

    factory :stanced_dummy_module_instance do
      #
      # Associations
      #

      association :module_class, :factory => :stanced_dummy_module_class
    end
  end
end