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

      context 'contents' do
        include_context 'Metasploit::Model::Module::Ancestor factory contents'

        let(:module_ancestor) do
          dummy_module_ancestor
        end

        context 'metasploit_module' do
          include_context 'Metasploit::Model::Module::Ancestor factory contents metasploit_module'

          # Classes are Modules, so this checks that it is either a Class or a Module.
          it { should be_a Module }
        end
      end
    end

    context 'payload_dummy_module_ancestor' do
      subject(:payload_dummy_module_ancestor) do
        FactoryGirl.build(:payload_dummy_module_ancestor)
      end

      it { should be_valid }

      its(:derived_payload_type) { should_not be_nil }

      it_should_behave_like 'Metasploit::Model::Module::Ancestor payload factory' do
        let(:module_ancestor) do
          payload_dummy_module_ancestor
        end
      end
    end

    context 'single_payload_dummy_module_ancestor' do
      subject(:single_payload_dummy_module_ancestor) do
        FactoryGirl.build(:single_payload_dummy_module_ancestor)
      end

      it { should be_valid }

      its(:derived_payload_type) { should == 'single' }

      it_should_behave_like 'Metasploit::Model::Module::Ancestor payload factory', handler_type: true do
        let(:module_ancestor) do
          single_payload_dummy_module_ancestor
        end
      end
    end

    context 'stage_payload_dummy_module_ancestor' do
      subject(:stage_payload_dummy_module_ancestor) do
        FactoryGirl.build(:stage_payload_dummy_module_ancestor)
      end

      it { should be_valid }

      its(:derived_payload_type) { should == 'stage' }

      it_should_behave_like 'Metasploit::Model::Module::Ancestor payload factory', handler_type: false do
        let(:module_ancestor) do
          stage_payload_dummy_module_ancestor
        end
      end
    end

    context 'stager_payload_dummy_module_ancestor' do
      subject(:stager_payload_dummy_module_ancestor) do
        FactoryGirl.build(:stager_payload_dummy_module_ancestor)
      end

      it { should be_valid }

      its(:derived_payload_type) { should == 'stager' }

      it_should_behave_like 'Metasploit::Model::Module::Ancestor payload factory', handler_type: true do
        let(:module_ancestor) do
          stager_payload_dummy_module_ancestor
        end
      end
    end
  end
end