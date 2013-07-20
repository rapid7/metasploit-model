require 'spec_helper'

describe Metasploit::Model::Authority do
  it_should_behave_like 'Metasploit::Model::Authority' do
    subject(:authority) do
      FactoryGirl.build :dummy_authority
    end
  end

  context 'factories' do
    context 'dummy_authority' do
      subject(:dummy_authority) do
        FactoryGirl.build(:dummy_authority)
      end

      it { should be_valid }
    end

    context 'full_dummy_authority' do
      subject(:full_dummy_authority) do
        FactoryGirl.build(:full_dummy_authority)
      end

      it { should be_valid }

      its(:summary) { should_not be_nil }
      its(:url) { should_not be_nil }
    end

    context 'obsolete_dummy_authority' do
      subject(:obsolete_dummy_authority) do
        FactoryGirl.build(:obsolete_dummy_authority)
      end

      it { should be_valid }

      its(:obsolete) { should be_true }
    end
  end
end