Metasploit::Model::Spec.shared_examples_for 'Module::Instance' do
  module_action_factory = "#{factory_namespace}_module_action"
  module_architecture_factory = "#{factory_namespace}_module_architecture"
  module_class_factory = "#{factory_namespace}_module_class"
  module_instance_factory = "#{factory_namespace}_module_instance"
  module_platform_factory = "#{factory_namespace}_module_platform"
  module_reference_factory = "#{factory_namespace}_module_reference"
  module_target_factory = "#{factory_namespace}_module_target"

  context 'CONSTANTS' do
    context 'MINIMUM_MODULE_AUTHORS_LENGTH' do
      subject(:minimum_module_authors_length) do
        described_class::MINIMUM_MODULE_AUTHORS_LENGTH
      end

      it { should == 1 }
    end

    context 'PRIVILEGES' do
      subject(:privileges) do
        described_class::PRIVILEGES
      end

      it 'should contain both Boolean values' do
        privileges.should include(false)
        privileges.should include(true)
      end
    end

    context 'SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE' do
      subject(:support_by_module_type_by_attribute) do
        described_class::SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE
      end

      context '[:actions]' do
        subject(:support_by_module_type) do
          support_by_module_type_by_attribute.fetch(:actions)
        end

        its([Metasploit::Model::Module::Type::AUX]) { should be_true }
        its([Metasploit::Model::Module::Type::ENCODER]) { should be_false }
        its([Metasploit::Model::Module::Type::EXPLOIT]) { should be_false }
        its([Metasploit::Model::Module::Type::NOP]) { should be_false }
        its([Metasploit::Model::Module::Type::PAYLOAD]) { should be_false }
        its([Metasploit::Model::Module::Type::POST]) { should be_false }
      end

      context '[:module_architectures]' do
        subject(:support_by_module_type) do
          support_by_module_type_by_attribute.fetch(:module_architectures)
        end

        its([Metasploit::Model::Module::Type::AUX]) { should be_false }
        its([Metasploit::Model::Module::Type::ENCODER]) { should be_true }
        its([Metasploit::Model::Module::Type::EXPLOIT]) { should be_true }
        its([Metasploit::Model::Module::Type::NOP]) { should be_true }
        its([Metasploit::Model::Module::Type::PAYLOAD]) { should be_true }
        its([Metasploit::Model::Module::Type::POST]) { should be_true }
      end

      context '[:module_platforms]' do
        subject(:support_by_module_type) do
          support_by_module_type_by_attribute.fetch(:module_platforms)
        end

        its([Metasploit::Model::Module::Type::AUX]) { should be_false }
        its([Metasploit::Model::Module::Type::ENCODER]) { should be_false }
        its([Metasploit::Model::Module::Type::EXPLOIT]) { should be_true }
        its([Metasploit::Model::Module::Type::NOP]) { should be_false }
        its([Metasploit::Model::Module::Type::PAYLOAD]) { should be_true }
        its([Metasploit::Model::Module::Type::POST]) { should be_true }
      end

      context '[:module_references]' do
        subject(:support_by_module_type) do
          support_by_module_type_by_attribute.fetch(:module_references)
        end

        its([Metasploit::Model::Module::Type::AUX]) { should be_true }
        its([Metasploit::Model::Module::Type::ENCODER]) { should be_false }
        its([Metasploit::Model::Module::Type::EXPLOIT]) { should be_true }
        its([Metasploit::Model::Module::Type::NOP]) { should be_false }
        its([Metasploit::Model::Module::Type::PAYLOAD]) { should be_false }
        its([Metasploit::Model::Module::Type::POST]) { should be_true }
      end

      context '[:stance]' do
        subject(:support_by_module_type) do
          support_by_module_type_by_attribute.fetch(:stance)
        end

        its([Metasploit::Model::Module::Type::AUX]) { should be_true }
        its([Metasploit::Model::Module::Type::ENCODER]) { should be_false }
        its([Metasploit::Model::Module::Type::EXPLOIT]) { should be_true }
        its([Metasploit::Model::Module::Type::NOP]) { should be_false }
        its([Metasploit::Model::Module::Type::PAYLOAD]) { should be_false }
        its([Metasploit::Model::Module::Type::POST]) { should be_false }
      end

      context '[:targets]' do
        subject(:support_by_module_type) do
          support_by_module_type_by_attribute.fetch(:targets)
        end

        its([Metasploit::Model::Module::Type::AUX]) { should be_false }
        its([Metasploit::Model::Module::Type::ENCODER]) { should be_false }
        its([Metasploit::Model::Module::Type::EXPLOIT]) { should be_true }
        its([Metasploit::Model::Module::Type::NOP]) { should be_false }
        its([Metasploit::Model::Module::Type::PAYLOAD]) { should be_false }
        its([Metasploit::Model::Module::Type::POST]) { should be_false }
      end
    end
  end

  context 'factories' do
    context module_instance_factory do
      subject(module_instance_factory) do
        FactoryGirl.build(module_instance_factory)
      end

      it { should be_valid }

      context 'Metasploit::Model::Module::Class#module_type' do
        subject(module_class_factory) do
          FactoryGirl.build(
              module_instance_factory,
              module_class: module_class
          )
        end

        let(:module_class) do
          FactoryGirl.create(
              module_class_factory,
              :module_type => module_type
          )
        end

        context 'with auxiliary' do
          let(:module_type) do
            'auxiliary'
          end

          it { should be_valid }

          it { should support :actions }
          it { should_not support :module_architectures }
          it { should_not support :module_platforms }
          it { should support :module_references }
          it { should support :stance }
          it { should_not support :targets }
        end

        context 'with encoder' do
          let(:module_type) do
            'encoder'
          end

          it { should be_valid }

          it { should_not support :actions }
          it { should support :module_architectures }
          it { should_not support :module_platforms }
          it { should_not support :module_references }
          it { should_not support :stance }
          it { should_not support :targets }
        end

        context 'with exploit' do
          let(:module_type) do
            'exploit'
          end

          it { should be_valid }

          it { should_not support :actions }
          it { should support :module_architectures }
          it { should support :module_platforms }
          it { should support :module_references }
          it { should support :stance }
          it { should support :targets }
        end

        context 'with nop' do
          let(:module_type) do
            'nop'
          end

          it { should be_valid }

          it { should_not support :actions }
          it { should support :module_architectures }
          it { should_not support :module_platforms }
          it { should_not support :module_references }
          it { should_not support :stance }
          it { should_not support :targets }
        end

        context 'with payload' do
          let(:module_type) do
            'payload'
          end

          it { should be_valid }

          it { should_not support :actions }
          it { should support :module_architectures }
          it { should support :module_platforms }
          it { should_not support :module_references }
          it { should_not support :stance }
          it { should_not support :targets }
        end

        context 'with post' do
          let(:module_type) do
            'post'
          end

          it { should be_valid }

          it { should_not support :actions }
          it { should support :module_architectures }
          it { should support :module_platforms }
          it { should support :module_references }
          it { should_not support :stance }
          it { should_not support :targets }
        end
      end
    end
  end

  context 'search' do
    context 'associations' do
      it_should_behave_like 'search_association', :actions
      it_should_behave_like 'search_association', :architectures
      it_should_behave_like 'search_association', :authorities
      it_should_behave_like 'search_association', :authors
      it_should_behave_like 'search_association', :email_addresses
      it_should_behave_like 'search_association', :module_class
      it_should_behave_like 'search_association', :platforms
      it_should_behave_like 'search_association', :rank
      it_should_behave_like 'search_association', :references
      it_should_behave_like 'search_association', :targets
    end

    context 'attributes' do
      it_should_behave_like 'search_attribute', :description, :type => :string
      it_should_behave_like 'search_attribute', :disclosed_on, :type => :date
      it_should_behave_like 'search_attribute', :license, :type => :string
      it_should_behave_like 'search_attribute', :name, :type => :string
      it_should_behave_like 'search_attribute', :privileged, :type => :boolean
      it_should_behave_like 'search_attribute', :stance, :type => :string
    end

    context 'withs' do
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::App,
                            :name => :app
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Author,
                            :name => :author
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Authority,
                            :abbreviation => :bid,
                            :name => :bid
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Authority,
                            :abbreviation => :cve,
                            :name => :cve
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Authority,
                            :abbreviation => :edb,
                            :name => :edb
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Authority,
                            :abbreviation => :osvdb,
                            :name => :osvdb
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Platform,
                            :name => :os
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Platform,
                            :name => :platform
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Ref,
                            :name => :ref
      it_should_behave_like 'search_with',
                            Metasploit::Model::Search::Operator::Deprecated::Text,
                            :name => :text
    end

    context 'query' do
      it_should_behave_like 'search query with Metasploit::Model::Search::Operator::Deprecated::App'
      it_should_behave_like 'search query with Metasploit::Model::Search::Operator::Deprecated::Authority',
                            :formatted_operator => 'bid'
      it_should_behave_like 'search query with Metasploit::Model::Search::Operator::Deprecated::Authority',
                            :formatted_operator => 'cve'
      it_should_behave_like 'search query', :formatted_operator => 'description'
      it_should_behave_like 'search query', :formatted_operator => 'disclosed_on'
      it_should_behave_like 'search query with Metasploit::Model::Search::Operator::Deprecated::Authority',
                            :formatted_operator => 'edb'
      it_should_behave_like 'search query', :formatted_operator => 'license'
      it_should_behave_like 'search query', :formatted_operator => 'name'
      it_should_behave_like 'search query', :formatted_operator => 'os'
      it_should_behave_like 'search query with Metasploit::Model::Search::Operator::Deprecated::Authority',
                            :formatted_operator => 'osvdb'
      it_should_behave_like 'search query', :formatted_operator => 'platform'
      it_should_behave_like 'search query', :formatted_operator => 'privileged'
      it_should_behave_like 'search query', :formatted_operator => 'ref'
      it_should_behave_like 'search query', :formatted_operator => 'stance'
      it_should_behave_like 'search query', :formatted_operator => 'text'

      it_should_behave_like 'search query', :formatted_operator => 'actions.name'

      context 'architectures' do
        it_should_behave_like 'search query', :formatted_operator => 'architectures.abbreviation'
        it_should_behave_like 'search query', :formatted_operator => 'architectures.bits'
        it_should_behave_like 'search query', :formatted_operator => 'architectures.endianness'
        it_should_behave_like 'search query', :formatted_operator => 'architectures.family'
      end

      it_should_behave_like 'search query', :formatted_operator => 'authorities.abbreviation'
      it_should_behave_like 'search query', :formatted_operator => 'authors.name'

      context 'email_addresses' do
        it_should_behave_like 'search query', :formatted_operator => 'email_addresses.domain'
        it_should_behave_like 'search query', :formatted_operator => 'email_addresses.local'
      end

      context 'module_class' do
        it_should_behave_like 'search query', :formatted_operator => 'module_class.full_name'
        it_should_behave_like 'search query', :formatted_operator => 'module_class.module_type'
        it_should_behave_like 'search query', :formatted_operator => 'module_class.payload_type'
        it_should_behave_like 'search query', :formatted_operator => 'module_class.reference_name'
      end

      it_should_behave_like 'search query', :formatted_operator => 'platforms.fully_qualified_name'

      context 'rank' do
        it_should_behave_like 'search query', :formatted_operator => 'rank.name'
        it_should_behave_like 'search query', :formatted_operator => 'rank.number'
      end

      context 'references' do
        it_should_behave_like 'search query', :formatted_operator => 'references.designation'
        it_should_behave_like 'search query', :formatted_operator => 'references.url'
      end

      it_should_behave_like 'search query', :formatted_operator => 'targets.name'
    end
  end

  context 'validations' do
    it_should_behave_like 'Metasploit::Model::Module::Instance validates supports',
                          :actions,
                          factory: module_action_factory

    it { should validate_presence_of :description }
    it { should validate_presence_of :license }

    it_should_behave_like 'Metasploit::Model::Module::Instance validates supports',
                          :module_architectures,
                          factory: module_architecture_factory

    it { should ensure_length_of(:module_authors) }

    context 'validate presence of module_class' do
      subject(:module_instance) do
        FactoryGirl.build(module_instance_factory, :module_class => module_class)
      end

      before(:each) do
        module_instance.valid?
      end

      context 'with module_class' do
        let(:module_class) do
          FactoryGirl.build(module_class_factory)
        end

        it 'should not record error on module_class' do
          module_instance.errors[:module_class].should be_empty
        end
      end

      context 'without module_class' do
        let(:module_class) do
          nil
        end

        it 'should record error on module_class' do
          module_instance.errors[:module_class].should include("can't be blank")
        end
      end
    end

    it_should_behave_like 'Metasploit::Model::Module::Instance validates supports',
                          :module_platforms,
                          factory: module_platform_factory
    it_should_behave_like 'Metasploit::Model::Module::Instance validates supports',
                          :module_references,
                          factory: module_reference_factory

    it { should validate_presence_of :name }

    context 'ensure inclusion of privileged is boolean' do
      let(:error) do
        'is not included in the list'
      end

      before(:each) do
        module_instance.privileged = privileged

        module_instance.valid?
      end

      context 'with nil' do
        let(:privileged) do
          nil
        end

        it 'should record error' do
          module_instance.errors[:privileged].should include(error)
        end
      end

      context 'with false' do
        let(:privileged) do
          false
        end

        it 'should not record error' do
          module_instance.errors[:privileged].should be_empty
        end
      end

      context 'with true' do
        let(:privileged) do
          true
        end

        it 'should not record error' do
          module_instance.errors[:privileged].should be_empty
        end
      end
    end

    context 'stance' do
      context 'module_type' do
        subject(:module_instance) do
          FactoryGirl.build(
              module_instance_factory,
              :module_class => module_class,
              # set by shared examples
              :stance => stance
          )
        end

        let(:module_class) do
          FactoryGirl.create(
              module_class_factory,
              # set by shared examples
              :module_type => module_type
          )
        end

        let(:stance) do
          nil
        end

        it_should_behave_like 'Metasploit::Model::Module::Instance supports stance with module_type', 'auxiliary'
        it_should_behave_like 'Metasploit::Model::Module::Instance supports stance with module_type', 'exploit'

        it_should_behave_like 'Metasploit::Model::Module::Instance does not support stance with module_type', 'encoder'
        it_should_behave_like 'Metasploit::Model::Module::Instance does not support stance with module_type', 'nop'
        it_should_behave_like 'Metasploit::Model::Module::Instance does not support stance with module_type', 'payload'
        it_should_behave_like 'Metasploit::Model::Module::Instance does not support stance with module_type', 'post'
      end
    end

    it_should_behave_like 'Metasploit::Model::Module::Instance validates supports',
                          :targets,
                          factory: module_target_factory
  end

  context '#supports?' do
    subject(:supports?) do
      module_instance.supports?(attribute)
    end

    context 'with known attribute' do
      let(:attribute) do
        [:actions, :module_architectures, :module_platforms, :module_references, :stance, :targets].sample
      end

      let(:module_instance) do
        FactoryGirl.build(
            module_instance_factory,
            module_class: module_class
        )
      end

      context 'with #module_class' do
        let(:module_class) do
          FactoryGirl.build(
              module_class_factory,
              # have to make ancestors empty so that invalid module_type can be used.
              ancestors: [],
              module_type: module_type
          )
        end

        before(:each) do
          module_instance.module_class.module_type = module_type
        end

        context 'with known module_type' do
          #
          # Use an attribute and module_type that will be supported so the true return can be differentiated from the
          # false return for nil module_class or unknown module_type
          #

          let(:attribute) do
            :actions
          end

          let(:module_type) do
            'auxiliary'
          end

          it 'should be Boolean' do
            supports?.should be_true
          end
        end

        context 'without known module_type' do
          let(:module_type) do
            :unknown_module_type
          end

          it { should be_false }
        end
      end

      context 'without #module_class' do
        let(:module_class) do
          nil
        end

        it { should be_false }
      end
    end

    context 'without known attribute' do
      let(:attribute) do
        :unknown_attribute
      end

      specify {
        expect {
          supports?
        }.to raise_error(KeyError)
      }
    end
  end
end