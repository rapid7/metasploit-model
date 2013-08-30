FactoryGirl.define do
  sequence :metasploit_model_architecture_abbreviation, Metasploit::Model::Architecture::ABBREVIATIONS.cycle
  sequence :metasploit_model_architecture_bits, Metasploit::Model::Architecture::BITS.cycle
  sequence :metasploit_model_architecture_endianness, Metasploit::Model::Architecture::ENDIANNESSES.cycle
  sequence :metasploit_model_architecture_family, Metasploit::Model::Architecture::FAMILIES.cycle
end