FactoryGirl.define do
  factory :dummy_module_action,
          :class => Dummy::Module::Action,
          :traits => [
              :metasploit_model_module_action
          ] do
    #
    # Associations
    #

    # @todo https://www.pivotaltracker.com/story/show/54626850
  end
end