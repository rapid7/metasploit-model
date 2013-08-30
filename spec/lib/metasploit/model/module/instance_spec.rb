require 'spec_helper'

describe Metasploit::Model::Module::Instance do
  subject(:module_instance) do
    FactoryGirl.build(:dummy_module_instance)
  end

  it_should_behave_like 'Metasploit::Model::Module::Instance' do
    let(:base_class) do
      Dummy::Module::Instance
    end

    let(:module_class_factory) do
      :dummy_module_class
    end

    let(:module_instance_factory) do
      :dummy_module_instance
    end
  end

  context 'factories' do
    context 'dummy_module_instance' do
      subject(:dummy_module_instance) do
        FactoryGirl.build(:dummy_module_instance)
      end

      it { should be_valid }

      context 'stance' do
        subject(:dummy_module_instance) do
          FactoryGirl.build(
              :dummy_module_instance,
              :module_class => module_class
          )
        end

        let(:module_class) do
          FactoryGirl.create(
              :dummy_module_class,
              :module_type => module_type
          )
        end

        context 'with supports_stance?' do
          let(:module_type) do
            'exploit'
          end

          it { should be_valid }

          its(:stance) { should_not be_nil }
          its(:supports_stance?) { should be_true }
        end

        context 'without supports_stance?' do
          let(:module_type) do
            'post'
          end

          it { should be_valid }

          its(:stance) { should be_nil }
          its(:supports_stance?) { should be_false }
        end
      end
    end

    context 'stanced_dummy_module_instance' do
      subject(:stanced_dummy_module_instance) do
        FactoryGirl.build(:stanced_dummy_module_instance)
      end

      it { should be_valid }

      its(:stance) { should_not be_nil }
      its(:supports_stance?) { should be_true }
    end
  end
end