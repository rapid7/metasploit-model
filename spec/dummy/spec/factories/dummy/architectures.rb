FactoryGirl.define do
  abbreviations = Metasploit::Model::Architecture::ABBREVIATIONS

  # dummy_architectures is not a factory, but a sequence because only the seeded Dummy::Architectures are valid
  sequence :dummy_architecture do |n|
    # use abbreviations since they are unique
    abbreviation = abbreviations[n % abbreviations.length]

    architecture = Dummy::Architecture.with_abbreviation(abbreviation)

    architecture
  end
end