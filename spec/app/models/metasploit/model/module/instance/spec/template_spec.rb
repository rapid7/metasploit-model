require 'spec_helper'

describe Metasploit::Model::Module::Instance::Spec::Template do
  subject(:template) do
    described_class.new(
        module_instance: module_instance
    )
  end

  let(:module_instance) do
    FactoryGirl.build(:dummy_module_instance)
  end

  context 'validations' do
    context '#class_template' do
      subject(:class_template_errors) do
        template.errors[:class_template]
      end

      context 'presence' do
        let(:error) do
          I18n.translate!('errors.messages.blank')
        end

        context 'with nil' do
          before(:each) do
            allow(template).to receive(:class_template).and_return(nil)
            template.valid?
          end

          it { should include error }
        end

        context 'without nil' do
          before(:each) do
            template.valid?
          end

          it { should_not include error }
        end
      end

      context '#class_template_valid' do
        let(:error) do
          I18n.translate!('errors.messages.invalid')
        end

        context 'with #class_template' do
          context 'with valid' do
            before(:each) do
              template.valid?
            end

            it { should_not include(error) }
          end

          context 'without valid' do
            before(:each) do
              expect(template.class_template).to receive(:valid?).and_return(false)
              template.valid?
            end

            it { should include(error) }
          end
        end

        context 'without #class_template' do
          before(:each) do
            allow(template).to receive(:class_template).and_return(nil)
            template.valid?
          end

          it { should_not include(error) }
        end
      end
    end

    it { should validate_presence_of :module_instance }
  end

  context '#class_template' do
    subject(:class_template) do
      template.class_template
    end

    context 'with #module_instance' do
      it { should be_a Metasploit::Model::Module::Class::Spec::Template }

      context '#ancestor_templates' do
        subject(:ancestor_templates) do
          class_template.ancestor_templates
        end

        context 'locals' do
          subject(:ancestor_template_locals) do
            ancestor_templates.map(&:locals)
          end

          context '[:module_instance]' do
            subject(:module_instances) do
              ancestor_template_locals.collect { |locals|
                locals[:module_instance]
              }
            end

            it 'is #module_instance' do
              expect(
                  module_instances.all? { |actual_module_instance|
                    actual_module_instance == module_instance
                  }
              ).to be_true
            end
          end
        end

        context 'search_pathnames' do
          subject(:search_pathnames) do
            ancestor_templates.map(&:search_pathnames)
          end

          it "has 'module/instances', then 'module/classes', then 'module/ancestors'" do
            search_pathnames.each do |actual_search_pathnames|
              module_instances_index = actual_search_pathnames.index(Pathname.new('module/instances'))
              module_classes_index = actual_search_pathnames.index(Pathname.new('module/classes'))
              module_ancestors_index = actual_search_pathnames.index(Pathname.new('module/ancestors'))

              expect(module_instances_index).to be < module_classes_index
              expect(module_classes_index).to be < module_ancestors_index
            end
          end
        end
      end

      context '#module_class' do
        it 'is module_instance.module_class' do
          expect(class_template.module_class).to eq(module_instance.module_class)
        end
      end
    end

    context 'without #module_instance' do
      let(:module_instance) do
        nil
      end

      it { should be_nil }
    end
  end

  context 'write' do
    subject(:write) do
      described_class.write(attributes)
    end

    context 'with valid' do
      let(:attributes) do
        {
            module_instance: module_instance
        }
      end

      it { should be_true }

      it 'writes template' do
        # memoize attributes so any other writes besides the one under-test are already run.
        attributes

        described_class.any_instance.should_receive(:write)

        write
      end
    end

    context 'without valid' do
      let(:attributes) do
        {}
      end

      it { should be_false }

      it 'does not write template' do
        described_class.any_instance.should_not_receive(:write)

        write
      end
    end
  end

  context '#write' do
    subject(:write) do
      template.write
    end

    it 'delegates to #class_template' do
      expected = double('#write')

      expect(template.class_template).to receive(:write).and_return(expected)
      expect(write).to eq(expected)
    end
  end
end