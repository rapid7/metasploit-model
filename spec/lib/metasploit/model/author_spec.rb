require 'spec_helper'

describe Metasploit::Model::Author do
  it_should_behave_like 'Metasploit::Model::Author' do
    subject(:author) do
      FactoryGirl.build(:dummy_author)
    end
  end

  context 'factories' do
    context 'dummy_author' do
      subject(:dummy_author) do
        FactoryGirl.build(:dummy_author)
      end

      it { should be_valid }
    end
  end
end