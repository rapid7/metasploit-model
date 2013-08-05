FactoryGirl.define do
  factory :dummy_email_address,
          :class => Dummy::EmailAddress,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_email_address
          ]
end