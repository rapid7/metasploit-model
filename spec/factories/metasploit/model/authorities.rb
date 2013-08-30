FactoryGirl.define do
  sequence :metasploit_model_authority_abbreviation do |n|
    # can't use '-' as {Metasploit::Model::Search::Operator::Deprecated::Ref} treats '-' as separating authority
    # abbreviation from reference designation.
    "METASPLOIT_MODEL_AUTHORITY#{n}"
  end

  sequence :metasploit_model_authority_summary do |n|
    "Metasploit::Model::Authority #{n}"
  end

  sequence :metasploit_model_authority_url do |n|
    "http://example.com/metasploit/model/authority/#{n}"
  end

  trait :metasploit_model_authority do
    abbreviation { generate :metasploit_model_authority_abbreviation }
  end

  trait :full_metasploit_model_authority do
    summary { generate :metasploit_model_authority_summary }
    url { generate :metasploit_model_authority_url }
  end

  trait :obsolete_metasploit_model_authority do
    obsolete { true }
  end
end