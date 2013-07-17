require 'spec_helper'

describe Metasploit::Model::Module::Path do
  subject(:path) do
    FactoryGirl.build(path_factory)
  end

  let(:path_factory) do
    :dummy_module_path
  end

  it_should_behave_like 'Metasploit::Model::Module::Path'

  context 'factories' do
    context 'dummy_module_path' do
      subject(:dummy_module_path) do
        FactoryGirl.build(:dummy_module_path)
      end

      it { should be_valid }
    end

    context 'named_dummy_module_path' do
      subject(:named_dummy_module_path) do
        FactoryGirl.build(:named_dummy_module_path)
      end

      it { should be_valid }

      its(:gem) { should_not be_nil }
      its(:name) { should_not be_nil }
    end

    context 'unnamed_dummy_module_path' do
      subject(:unnamed_dummy_module_path) do
        FactoryGirl.build(:unnamed_dummy_module_path)
      end

      it { should be_valid }

      its(:gem) { should be_nil }
      its(:name) { should be_nil }
    end
  end
end