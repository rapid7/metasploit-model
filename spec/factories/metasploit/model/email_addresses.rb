FactoryGirl.define do
  sequence :metasploit_model_email_address_domain do |n|
    "metasploit-model-email-address-domain#{n}.com"
  end

  sequence :metasploit_model_email_address_local do |n|
    "metasploit.model.email.address.local+#{n}"
  end

  trait :metasploit_model_email_address do
    domain { generate :metasploit_model_email_address_domain }
    local { generate :metasploit_model_email_address_local }
  end
end