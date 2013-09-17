require 'spec_helper'

describe Metasploit::Model::Module::Class do
  it_should_behave_like 'Metasploit::Model::Module::Class' do
    subject(:module_class) do
      FactoryGirl.build(module_class_factory)
    end

    def attribute_type(attribute)
      type_by_attribute = {
          :full_name => :text,
          :module_type => :string,
          :payload_type => :string,
          :reference_name => :text
      }

      type = type_by_attribute.fetch(attribute)

      type
    end

    let(:base_class) do
      module_class_class
    end

    let(:module_ancestor_factory) do
      :dummy_module_ancestor
    end

    let(:module_class_class) do
      Dummy::Module::Class
    end

    let(:module_class_factory) do
      :dummy_module_class
    end

    let(:non_payload_module_ancestor_factory) do
      :non_payload_dummy_module_ancestor
    end

    let(:payload_module_ancestor_factory) do
      :payload_dummy_module_ancestor
    end

    let(:single_payload_module_ancestor_factory) do
      :single_payload_dummy_module_ancestor
    end

    let(:stage_payload_module_ancestor_factory) do
      :stage_payload_dummy_module_ancestor
    end

    let(:stager_payload_module_ancestor_factory) do
      :stager_payload_dummy_module_ancestor
    end
  end

  context 'factories' do
    context 'dummy_module_class' do
      subject(:dummy_module_class) do
        FactoryGirl.build(:dummy_module_class)
      end

      it { should be_valid }

      context '#ancestors' do
        subject(:ancestors) do
          dummy_module_class.ancestors
        end

        context 'Metasploit::Model::Module::Ancestor#contents list' do
          subject(:contents_list) do
            ancestors.map(&:contents)
          end

          before(:each) do
            # need to validate so that real_path is derived so contents can be read
            ancestors.each(&:valid?)
          end

          context 'metasploit_modules' do
            include_context 'Metasploit::Model::Module::Ancestor#contents metasploit_module'

            subject(:metasploit_modules) do
              namespace_modules.collect { |namespace_module|
                namespace_module_metasploit_module(namespace_module)
              }
            end

            let(:namespace_modules) do
              ancestors.collect {
                Module.new
              }
            end

            before(:each) do
              namespace_modules.zip(contents_list) do |namespace_module, contents|
                namespace_module.module_eval(contents)
              end
            end

            context 'rank_names' do
              subject(:rank_names) do
                metasploit_modules.collect { |metasploit_module|
                  metasploit_module.rank_name
                }
              end

              it 'should match Metasploit::Model::Module::Class#rank Metasploit::Model:Module::Rank#name' do
                rank_names.all? { |rank_name|
                  rank_name == dummy_module_class.rank.name
                }.should be_true
              end
            end

            context 'rank_numbers' do
              subject(:rank_numbers) do
                metasploit_modules.collect { |metasploit_module|
                  metasploit_module.rank_number
                }
              end

              it 'should match Metasploit::Model::Module::Class#rank Metasploit::Module::Module::Rank#number' do
                rank_numbers.all? { |rank_number|
                  rank_number == dummy_module_class.rank.number
                }.should be_true
              end
            end
          end
        end
      end

      context 'module_type' do
        subject(:dummy_module_class) do
          FactoryGirl.build(
              :dummy_module_class,
              :module_type => module_type
          )
        end

        context 'with payload' do
          let(:module_type) do
            'payload'
          end

          it { should be_valid }

          context 'with payload_type' do
            subject(:dummy_module_class) do
              FactoryGirl.build(
                  :dummy_module_class,
                  :module_type => module_type,
                  :payload_type => payload_type
              )
            end

            context 'single' do
              let(:payload_type) do
                'single'
              end

              it { should be_valid }
            end

            context 'staged' do
              let(:payload_type) do
                'staged'
              end

              it { should be_valid }
            end

            context 'other' do
              let(:payload_type) do
                'not_a_payload_type'
              end

              it 'should raise ArgumentError' do
                expect {
                  dummy_module_class
                }.to raise_error(ArgumentError)
              end
            end
          end
        end

        context 'without payload' do
          let(:module_type) do
            FactoryGirl.generate :metasploit_model_non_payload_module_type
          end

          it { should be_valid }

          its(:derived_module_type) { should == module_type }
        end
      end

      context 'ancestors' do
        subject(:dummy_module_class) do
          FactoryGirl.build(
              :dummy_module_class,
              :ancestors => ancestors
          )
        end

        if RUBY_PLATFORM =~ /java/
          def ancestor_count
            count = 0

            # generalized each_object(<class>) is not turned on in jruby
            ObjectSpace.each_object(::Class) do |instance|
              if instance.is_a? Dummy::Module::Ancestor
                count += 1
              end
            end

            count
          end
        else
          def ancestor_count
            count = 0

            ObjectSpace.each_object(Dummy::Module::Ancestor) do |_ancestor|
              count += 1
            end

            count
          end
        end

        context 'single payload' do
          let!(:ancestors) do
            [
              FactoryGirl.create(:single_payload_dummy_module_ancestor)
            ]
          end

          it { should be_valid }

          it 'should not create any Mdm::Module::Ancestors' do
            expect {
              dummy_module_class
            }.to_not change(self, :ancestor_count)
          end
        end

        context 'stage payload and stager payload' do
          let!(:ancestors) do
            [
                FactoryGirl.create(:stage_payload_dummy_module_ancestor),
                FactoryGirl.create(:stager_payload_dummy_module_ancestor)
            ]
          end

          it { should be_valid }

          it 'should not create any Mdm::Module::Ancestors' do
            expect {
              dummy_module_class
            }.to_not change(self, :ancestor_count)
          end
        end
      end
    end

    context 'stanced_dummy_module_class' do
      subject(:stanced_dummy_module_class) do
        FactoryGirl.build(:stanced_dummy_module_class)
      end

      it { should be_valid }

      its(:derived_module_type) { should be_in Metasploit::Model::Module::Instance::STANCED_MODULE_TYPES }
    end
  end
end