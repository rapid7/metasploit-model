FactoryGirl.define do
  factory :dummy_platform,
          :class => Dummy::Platform,
          :traits => [
              :metasploit_model_platform
          ]
end