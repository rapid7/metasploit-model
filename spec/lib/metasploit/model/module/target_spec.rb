require 'spec_helper'

describe Metasploit::Model::Module::Target do
	it_should_behave_like 'Metasploit::Model::Module::Target' do
    subject(:target) do
      FactoryGirl.build(:dummy_module_target)
    end
  end

  context 'factories' do
    context 'dummy_module_target' do
      subject(:dummy_module_target) do
        FactoryGirl.build :dummy_module_target
      end

      it { should be_valid }
    end
  end
end