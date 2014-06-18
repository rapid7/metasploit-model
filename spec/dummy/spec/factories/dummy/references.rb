FactoryGirl.define do
  factory :dummy_reference,
          :class => Dummy::Reference,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_reference
          ] do
    #
    # Associations
    #

    association :authority, :factory => :dummy_authority

    factory :obsolete_dummy_reference,
            :traits => [
                :obsolete_metasploit_model_reference
            ] do
      association :authority, :factory => :obsolete_dummy_authority
    end

    factory :url_dummy_reference,
            :traits => [
                :url_metasploit_model_reference
            ]
  end
end