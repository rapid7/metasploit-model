require 'spec_helper'

describe Metasploit::Model::Module::Class::Spec::Template do
  subject(:template) do
    described_class.new(
        module_class: module_class
    )
  end

  let(:module_class) do
    FactoryGirl.build(
        :dummy_module_class
    )
  end

  context 'validations' do
    it { should validate_presence_of :module_class }

    context '#ancestor_templates_valid' do
      subject(:ancestor_templates_valid) do
        template.send(:ancestor_templates_valid)
      end

      #
      # let
      #

      let(:error) do
        I18n.translate!(:'errors.messages.invalid')
      end

      #
      # Callbacks
      #

      before(:each) do
        allow(template).to receive(:ancestor_templates).and_return(ancestor_templates)
      end

      context 'with ancestor_templates' do
        #
        # lets
        #

        let(:ancestor_templates) do
          Array.new(2) { |i|
            double("Ancestor Template #{i}")
          }
        end

        #
        # Callbacks
        #

        context 'with all valid' do
          before(:each) do
            ancestor_templates.each do |child|
              child.stub(valid?: true)
            end
          end

          it 'does not add error on :ancestor_templates' do
            template.valid?

            template.errors[:ancestor_templates].should_not include(error)
          end
        end

        context 'with later valid' do
          before(:each) do
            ancestor_templates.first.stub(valid?: false)
            ancestor_templates.second.stub(valid?: true)
          end

          it 'does not short-circuit and validates all ancestor_templates' do
            ancestor_templates.second.should_receive(:valid?).and_return(true)

            ancestor_templates_valid
          end

          it 'should add error on :ancestor_templates' do
            template.valid?

            template.errors[:ancestor_templates].should include(error)
          end
        end
      end

      context 'without ancestor_templates' do
        let(:ancestor_templates) do
          []
        end

        it 'does not add error on :ancestor_templates' do
          template.valid?

          template.errors[:ancestor_templates].should_not include(error)
        end
      end
    end
  end

  context '#ancestor_templates' do
    subject(:ancestor_templates) do
      template.ancestor_templates
    end

    it 'creates Metasploit::Model::Module::Ancestor::Spec::Template for each ancestor in module_class.ancestors' do
      template_module_ancestors = ancestor_templates.map(&:module_ancestor)

      expect(template_module_ancestors).to match_array(module_class.ancestors)
    end

    context 'Metasploit::Model::Module::Ancestor::Spec::Template' do
      context 'locals' do
        subject(:ancestor_template_locals) do
          ancestor_templates.map(&:locals)
        end

        context '[:module_class]' do
          subject(:local_module_classes) do
            ancestor_template_locals.collect { |locals|
              locals[:module_class]
            }
          end

          it 'is #module_class' do
            expect(
                local_module_classes.all? { |local_module_class|
                  local_module_class == module_class
                }
            ).to be_true
          end
        end
      end

      context 'overwrite' do
        subject(:overwrites) do
          ancestor_templates.map(&:overwrite)
        end

        it 'is true so the the ancestor written templates will be overwritten by the class templates' do
          expect(
              overwrites.all? { |overwrite|
                overwrite == true
              }
          ).to be_true
        end
      end

      context 'search_pathnames' do
        subject(:search_pathnames) do
          ancestor_templates.map(&:search_pathnames)
        end

        it "has 'module/classes' before 'module/ancestors'" do
          expect(
              search_pathnames.all? { |template_search_pathnames|
                module_classes_index = template_search_pathnames.index(Pathname.new('module/classes'))
                module_ancestors_index = template_search_pathnames.index(Pathname.new('module/ancestors'))

                module_classes_index < module_ancestors_index
              }
          ).to be_true
        end
      end
    end
  end

  context 'write' do
    subject(:write) do
      described_class.write(attributes)
    end

    context 'with valid' do
      let(:attributes) do
        {
            module_class: module_class
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

    it 'writes each ancestor template' do
      template.ancestor_templates.each do |ancestor_template|
        expect(ancestor_template).to receive(:write)
      end

      write
    end
  end
end