require 'spec_helper'

describe Metasploit::Model::Module::Author do
  subject(:author) do
    FactoryGirl.build(:dummy_module_author)
  end

  it_should_behave_like 'Metasploit::Model::Module::Author'

  context 'factories' do
    context 'dummy_module_author' do
      subject(:dummy_module_author) do
        FactoryGirl.build(:dummy_module_author)
      end

      it 'should be valid', :pending => 'https://www.pivotaltracker.com/story/show/54632646' do
        dummy_module_author.should be_valid
      end
    end

    context 'full_dummy_module_author' do
      subject(:full_dummy_module_author) do
        FactoryGirl.build(:full_dummy_module_author)
      end

      it 'should be valid', :pending => 'https://www.pivotaltracker.com/story/show/54632646' do
        full_dummy_module_author.should be_valid
      end

      its(:email_address) { should_not be_nil }
    end
  end
end