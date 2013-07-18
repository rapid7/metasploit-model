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
end