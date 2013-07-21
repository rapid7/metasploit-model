FactoryGirl.define do
  factory :dummy_authority,
          :class => Dummy::Authority,
          :traits => [
              :metasploit_model_authority
          ] do
    to_create do |instance|
      # validate so before validation derivation occurs to mimic create for ActiveRecord.
      unless instance.valid?
        raise Metasploit::Model::Invalid.new(instance)
      end
    end

    factory :full_dummy_authority,
            :traits => [
                :full_metasploit_model_authority
            ]

    factory :obsolete_dummy_authority,
            :traits => [
                :obsolete_metasploit_model_authority
            ]
  end

  seed_abbreviations = Dummy::Authority::SEED_ATTRIBUTES.collect { |attributes|
    attributes[:abbreviation]
  }

  seed_abbreviation_count = seed_abbreviations.length

  sequence :seeded_dummy_authority do |n|
    seed_abbreviation = seed_abbreviations[n % seed_abbreviation_count]

    authority = Dummy::Authority.with_abbreviation(seed_abbreviation)

    authority
  end
end