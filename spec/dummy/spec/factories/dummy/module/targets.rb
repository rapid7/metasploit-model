FactoryGirl.define do
  factory :dummy_module_target,
          :class => Dummy::Module::Target,
          :traits => [
              :metasploit_model_module_target
          ] do
    #
    # Associations
    #

    # @todo https://www.pivotaltracker.com/story/show/54645410
  end
end