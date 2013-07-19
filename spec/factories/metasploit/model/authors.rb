FactoryGirl.define do
  sequence :metasploit_model_author_name do |n|
    "Metasploit::Model::Author #{n}"
  end

  trait :metasploit_model_author do
    name { generate :metasploit_model_author_name }
  end
end