FactoryGirl.define do
  # Dummy::Module::Rank does not have a factory because all valid records are seeded, so it only has a sequence to grab
  # a seeded record

  names = Metasploit::Model::Module::Rank::NUMBER_BY_NAME.keys

  sequence :dummy_module_rank do |n|
    name = names[n % names.length]

    rank = Dummy::Module::Rank.with_name(name)

    rank
  end
end