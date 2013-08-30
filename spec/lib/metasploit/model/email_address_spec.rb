require 'spec_helper'

describe Metasploit::Model::EmailAddress do
  it_should_behave_like 'Metasploit::Model::EmailAddress' do
    subject(:email_address) do
      FactoryGirl.build(:dummy_email_address)
    end

    let(:email_address_class) do
      Dummy::EmailAddress
    end
  end

  context 'factories' do
    context 'dummy_email_address' do
      subject(:dummy_email_address) do
        FactoryGirl.build(:dummy_email_address)
      end

      it { should be_valid }
    end
  end
end