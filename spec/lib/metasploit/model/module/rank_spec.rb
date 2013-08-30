require 'spec_helper'

describe Metasploit::Model::Module::Rank do
  it_should_behave_like 'Metasploit::Model::Module::Rank' do
    subject(:rank) do
      rank_class.new
    end

    let(:rank_class) do
      Dummy::Module::Rank
    end
  end

  context 'sequences' do
    context 'metasploit_model_module_rank_name' do
      subject(:metasploit_model_module_rank_name) do
        FactoryGirl.generate :metasploit_model_module_rank_name
      end

      it 'should be key in Metasploit::Model::Module::Rank::NUMBER_BY_NAME' do
        Metasploit::Model::Module::Rank::NUMBER_BY_NAME.should have_key(metasploit_model_module_rank_name)
      end
    end

    context 'metasploit_model_module_rank_number' do
      subject(:metasploit_model_module_rank_number) do
        FactoryGirl.generate :metasploit_model_module_rank_number
      end

      it 'should be value in Metasploit::Model::Module::Rank::NUMBER_BY_NAME' do
        Metasploit::Model::Module::Rank::NUMBER_BY_NAME.should have_value(metasploit_model_module_rank_number)
      end
    end
  end
end