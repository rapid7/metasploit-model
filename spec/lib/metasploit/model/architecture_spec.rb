require 'spec_helper'

describe Metasploit::Model::Architecture do
  it_should_behave_like 'Metasploit::Model::Architecture' do
    subject(:architecture) do
      FactoryGirl.generate(:dummy_architecture)
    end
  end
end