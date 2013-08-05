require 'spec_helper'

describe Metasploit::Model::Module::Action do
  subject(:action) do
    FactoryGirl.build(:dummy_module_action)
  end

  it_should_behave_like 'Metasploit::Model::Module::Action'

  context 'factories' do
    context 'dummy_module_action' do
      let(:dummy_module_action) do
        FactoryGirl.build(:dummy_module_action)
      end

      it 'should be valid', :pending => 'https://www.pivotaltracker.com/story/show/54626850' do
        dummy_module_action.should be_valid
      end
    end
  end
end