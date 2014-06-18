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

  it_should_behave_like 'Metasploit::Model::Module::Instance::ClassMethods' do
    let(:singleton_class) do
      described_class
    end
  end

  context 'module_types_that_allow' do
    subject(:module_types_that_allow) do
      described_class.module_types_that_allow(attribute)
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
      it { should include 'post' }
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

    context 'DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE' do
      let(:attribute) do
        :attribute
      end

      let(:module_type) do
        FactoryGirl.generate :metasploit_model_module_type
      end

      before(:each) do
        described_class::DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE.should_receive(:fetch).with(
            attribute
        ).and_return(
            dynamic_length_validation_options_by_module_type
        )
      end

      context 'with :is' do
        let(:dynamic_length_validation_options_by_module_type) do
          {
              module_type => {
                  is: is
              }
          }
        end

        context '> 0' do
          let(:is) do
            1
          end

          it 'includes module type' do
            expect(module_types_that_allow).to include(module_type)
          end
        end

        context '<= 0' do
          let(:is) do
            0
          end

          it 'does not include module type' do
            expect(module_types_that_allow).not_to include(module_type)
          end
        end
      end

      context 'without :is' do
        context 'with :maximum' do
          let(:dynamic_length_validation_options_by_module_type) do
            {
                module_type => {
                    maximum: maximum
                }
            }
          end

          context '> 0' do
            let(:maximum) do
              1
            end

            it 'includes module type' do
              expect(module_types_that_allow).to include(module_type)
            end
          end

          context '<= 0' do
            let(:maximum) do
              0
            end

            it 'does not include module type' do
              expect(module_types_that_allow).not_to include(module_type)
            end
          end

        end

        context 'without :maximum' do
          let(:dynamic_length_validation_options_by_module_type) do
            {
                module_type => {}
            }
          end

          it 'includes module type' do
            expect(module_types_that_allow).to include(module_type)
          end
        end
      end
    end
  end
end