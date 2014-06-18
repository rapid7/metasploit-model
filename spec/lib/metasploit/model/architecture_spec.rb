require 'spec_helper'

describe Metasploit::Model::Architecture do
  it_should_behave_like 'Metasploit::Model::Architecture',
                        namespace_name: 'Dummy' do
    let(:seed) do
      Dummy::Architecture.with_abbreviation(abbreviation)
    end
  end

  context 'sequences' do
    context 'metasploit_model_architecture_abbreviation' do
      subject(:metasploit_model_architecture_abbreviation) do
        FactoryGirl.generate :metasploit_model_architecture_abbreviation
      end

      it 'should be an element of Metasploit::Model::Architecture::ABBREVIATIONS' do
        Metasploit::Model::Architecture::ABBREVIATIONS.should include(metasploit_model_architecture_abbreviation)
      end
    end

    context 'metasploit_model_architecture_bits' do
      subject(:metasploit_model_architecture_bits) do
        FactoryGirl.generate :metasploit_model_architecture_bits
      end

      it 'should be an element of Metasploit::Model::Architecture::BITS' do
        Metasploit::Model::Architecture::BITS.should include(metasploit_model_architecture_bits)
      end
    end

    context 'metasploit_model_architecture_endianness' do
      subject(:metasploit_model_architecture_endianness) do
        FactoryGirl.generate :metasploit_model_architecture_endianness
      end

      it 'should be an element of Metasploit::Model::Architecture::ENDIANNESSES' do
        Metasploit::Model::Architecture::ENDIANNESSES.should include(metasploit_model_architecture_endianness)
      end
    end

    context 'metasploit_model_architecture_family' do
      subject(:metasploit_model_architecture_family) do
        FactoryGirl.generate :metasploit_model_architecture_family
      end

      it 'should be an element of Metasploit::Model::Architecture::FAMILIES' do
        Metasploit::Model::Architecture::FAMILIES.should include(metasploit_model_architecture_family)
      end
    end
  end
end