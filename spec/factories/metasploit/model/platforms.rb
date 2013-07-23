FactoryGirl.define do
  sequence :metasploit_model_platform_name do |n|
    "Metasploit::Model::Platform#name #{n}"
  end

  trait :metasploit_model_platform do
    name { generate :metasploit_model_platform_name }
  end
end