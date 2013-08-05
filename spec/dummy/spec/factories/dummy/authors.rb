FactoryGirl.define do
  factory :dummy_author,
          :class => Dummy::Author,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_author
          ]
end