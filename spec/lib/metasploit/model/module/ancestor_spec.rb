require 'spec_helper'

describe Metasploit::Model::Module::Ancestor do
  subject(:ancestor) do
    FactoryGirl.build(ancestor_factory)
  end

  let(:ancestor_class) do
    Dummy::Module::Ancestor
  end

  let(:ancestor_factory) do
    :dummy_module_ancestor
  end

  let(:path_factory) do
    :dummy_module_path
  end

  it_should_behave_like 'Metasploit::Model::Module::Ancestor'

  context 'factories' do
    context 'dummy_module_ancestor' do
      subject(:dummy_module_ancestor) do
        FactoryGirl.build(:dummy_module_ancestor)
      end

      it { should be_valid }
    end

    context 'payload_dummy_module_ancestor' do
      subject(:payload_dummy_module_ancestor) do
        FactoryGirl.build(:payload_dummy_module_ancestor)
      end

      it { should be_valid }

      its(:module_type) { should == 'payload' }
      its(:derived_payload_type) { should_not be_nil }
    end

    context 'single_payload_dummy_module_ancestor' do
      subject(:single_payload_dummy_module_ancestor) do
        FactoryGirl.build(:single_payload_dummy_module_ancestor)
      end

      it { should be_valid }

      its(:module_type) { should == 'payload' }
      its(:derived_payload_type) { should == 'single' }
    end

    context 'stage_payload_dummy_module_ancestor' do
      subject(:stage_payload_dummy_module_ancestor) do
        FactoryGirl.build(:stage_payload_dummy_module_ancestor)
      end

      it { should be_valid }

      its(:module_type) { should == 'payload' }
      its(:derived_payload_type) { should == 'stage' }
    end

    context 'stager_payload_dummy_module_ancestor' do
      subject(:stager_payload_dummy_module_ancestor) do
        FactoryGirl.build(:stager_payload_dummy_module_ancestor)
      end

      it { should be_valid }

      its(:module_type) { should == 'payload' }
      its(:derived_payload_type) { should == 'stager' }
    end
  end
end