require 'spec_helper'

describe Metasploit::Model::Module::Action do
  subject(:action) do
    FactoryGirl.build(:dummy_module_action)
  end

  it_should_behave_like 'Metasploit::Model::Module::Action' do
    let(:base_class) do
      Dummy::Module::Action
    end
  end

  context 'factories' do
    context 'dummy_module_action' do
      let(:dummy_module_action) do
        FactoryGirl.build(:dummy_module_action)
      end

      it { should be_valid }
    end
  end
end