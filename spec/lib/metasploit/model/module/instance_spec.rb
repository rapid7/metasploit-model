require 'spec_helper'

describe Metasploit::Model::Module::Instance,
         # setting the metadata type makes rspec-rails include RSpec::Rails::ModelExampleGroup, which includes a better
         # be_valid matcher that will print full error messages
         type: :model do
  subject(:module_instance) do
    FactoryGirl.build(:dummy_module_instance)
  end

  it_should_behave_like 'Metasploit::Model::Module::Instance',
                        namespace_name: 'Dummy'

  # not in 'Metasploit::Model::Module::Instance' shared example since it's not in ClassMethods, but an actual module
  # method on Metasploit::Model::Module::Instance for use in metasploit-model factories.
  context 'module_type_supports?' do
    subject(:module_type_supports?) do
      described_class.module_type_supports?(module_type, attribute)
    end

    context 'with known attribute' do
      let(:attribute) do
        [:actions, :module_architectures, :module_platforms, :module_references, :stance, :targets].sample
      end

      context 'with known module_type' do
        let(:module_type) do
          FactoryGirl.generate :metasploit_model_module_type
        end

        it 'should be Boolean' do
          support = module_type_supports?

          support.should be_in [false, true]
        end
      end

      context 'without known module_type' do
        let(:module_type) do
          :unknown_module_type
        end

        specify {
          expect {
            module_type_supports?
          }.to raise_error(KeyError)
        }
      end
    end

    context 'without known attribute' do
      let(:attribute) do
        :unknown_attribute
      end

      context 'with known module_type' do
        let(:module_type) do
          FactoryGirl.generate :metasploit_model_module_type
        end

        specify {
          expect {
            module_type_supports?
          }.to raise_error(KeyError)
        }
      end

      context 'without known module_type' do
        let(:module_type) do
          :unknown_module_type
        end

        specify {
          expect {
            module_type_supports?
          }.to raise_error(KeyError)
        }
      end
    end
  end

  context 'module_types_that_support' do
    subject(:module_types_that_support) do
      described_class.module_types_that_support(attribute)
    end

    context 'with actions' do
      let(:attribute) do
        :actions
      end

      it { should include 'auxiliary' }
      it { should_not include 'encoder' }
      it { should_not include 'exploit' }
      it { should_not include 'nop' }
      it { should_not include 'payload' }
      it { should_not include 'post' }
    end

    context 'with module_architectures' do
      let(:attribute) do
        :module_architectures
      end

      it { should_not include 'auxiliary' }
      it { should include 'encoder' }
      it { should include 'exploit' }
      it { should include 'nop' }
      it { should include 'payload' }
      it { should include 'post' }
    end

    context 'with module_platforms' do
      let(:attribute) do
        :module_platforms
      end

      it { should_not include 'auxiliary' }
      it { should_not include 'encoder' }
      it { should include 'exploit' }
      it { should_not include 'nop' }
      it { should include 'payload' }
      it { should include 'post' }
    end

    context 'with module_references' do
      let(:attribute) do
        :module_references
      end

      it { should include 'auxiliary' }
      it { should_not include 'encoder' }
      it { should include 'exploit' }
      it { should_not include 'nop' }
      it { should_not include 'payload' }
      it { should include 'post' }
    end

    context 'with stance' do
      let(:attribute) do
        :stance
      end

      it { should include 'auxiliary' }
      it { should_not include 'encoder' }
      it { should include 'exploit' }
      it { should_not include 'nop' }
      it { should_not include 'payload' }
      it { should_not include 'post' }
    end

    context 'with targets' do
      let(:attribute) do
        :targets
      end

      it { should_not include 'auxiliary' }
      it { should_not include 'encoder' }
      it { should include 'exploit' }
      it { should_not include 'nop' }
      it { should_not include 'payload' }
      it { should_not include 'post' }
    end
  end
end