require 'spec_helper'

describe Metasploit::Model::Platform do
  it_should_behave_like 'Metasploit::Model::Platform' do
    subject(:platform) do
      FactoryGirl.build(:dummy_platform)
    end
  end
end