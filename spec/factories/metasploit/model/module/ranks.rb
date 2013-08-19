FactoryGirl.define do
  number_by_name = Metasploit::Model::Module::Rank::NUMBER_BY_NAME

  names = number_by_name.keys
  sequence :metasploit_model_module_rank_name, names.cycle

  numbers = number_by_name.values
  sequence :metasploit_model_module_rank_number, numbers.cycle
end