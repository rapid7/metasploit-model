Metasploit::Model::Spec.shared_examples_for 'Module::Instance' do
  #
  # Classes
  #

  architecture_class = "#{namespace_name}::Architecture".constantize
  platform_class = "#{namespace_name}::Platform".constantize

  #
  # Factories
  #

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
    subject(:module_instance) do
      FactoryGirl.build(
          module_instance_factory,
          module_class: module_class
      )
    end

    let(:module_class) do
      FactoryGirl.create(
          module_class_factory,
          module_type: module_type
      )
    end

    let(:module_type) do
      module_types.sample
    end

    let(:module_types) do
      Metasploit::Model::Module::Type::ALL
    end

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

    context 'with supports?(:targets)' do
      let(:module_instance) do
        FactoryGirl.build(
            module_instance_factory,
            module_class: module_class,
            # create targets manually to control the number of target architectures and target platforms
            targets_length: 0
        ).tap { |module_instance|
          FactoryGirl.build(
              module_target_factory,
              module_instance: module_instance,
              # need to restrict to 1 architecture and platform to ensure there is an extra architecture or platform
              # available.
              target_architectures_length: 1,
              target_platforms_length: 1
          )
        }
      end

      let(:module_types) do
        support_by_module_type = Metasploit::Model::Module::Instance::SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE.fetch(:targets)

        support_by_module_type.each_with_object([]) { |(module_type, support), module_types|
          if support
            module_types << module_type
          end
        }
      end

      context '#architectures errors' do
        subject(:architectures_errors) do
          module_instance.errors[:architectures]
        end

        context '#architectures_from_targets' do
          context 'with same architectures' do
            before(:each) do
              module_instance.valid?
            end

            it { should be_empty }
          end

          context 'without same architectures' do
            context 'with extra architectures' do
              #
              # Lets
              #

              let(:error) do
                I18n.translate(
                    'metasploit.model.errors.models.metasploit/model/module/instance.attributes.architectures.extra',
                    extra: human_architecture_set
                )
              end

              let(:expected_architecture_set) do
                module_instance.targets.each_with_object(Set.new) do |module_target, set|
                  module_target.target_architectures.each do |target_architecture|
                    set.add target_architecture.architecture
                  end
                end
              end

              let(:extra_architecture) do
                extra_architectures.sample
              end

              let(:extra_architectures) do
                architecture_class.all - expected_architecture_set.to_a
              end

              let(:human_architecture_set) do
                "{#{extra_architecture.abbreviation}}"
              end

              #
              # Callbacks
              #

              before(:each) do
                module_instance.module_architectures <<  FactoryGirl.build(
                    module_architecture_factory,
                    architecture: extra_architecture,
                    module_instance: module_instance
                )

                module_instance.valid?
              end

              it 'includes extra error' do
                expect(architectures_errors).to include(error)
              end
            end

            context 'with missing architectures' do
              #
              # Lets
              #

              let(:error) do
                I18n.translate(
                    'metasploit.model.errors.models.metasploit/model/module/instance.attributes.architectures.missing',
                    missing: human_architecture_set
                )
              end

              let(:human_architecture_set) do
                "{#{missing_architecture.abbreviation}}"
              end

              let(:missing_architecture) do
                missing_module_architecture.architecture
              end

              let(:missing_module_architecture) do
                module_instance.module_architectures.sample
              end

              #
              # Callbacks
              #

              before(:each) do
                module_instance.module_architectures.reject! { |module_architecture|
                  module_architecture == missing_module_architecture
                }

                module_instance.valid?
              end

              it 'includes missing error' do
                expect(architectures_errors).to include(error)
              end
            end
          end
        end
      end

      context '#platforms errors' do
        subject(:platforms_errors) do
          module_instance.errors[:platforms]
        end

        context '#platforms_from_targets' do
          context 'with same platforms' do
            before(:each) do
              module_instance.valid?
            end

            it { should be_empty }
          end

          context 'without same platforms' do
            context 'with extra platforms' do
              #
              # Lets
              #

              let(:error) do
                I18n.translate(
                    'metasploit.model.errors.models.metasploit/model/module/instance.attributes.platforms.extra',
                    extra: human_platform_set
                )
              end

              let(:expected_platform_set) do
                module_instance.targets.each_with_object(Set.new) do |module_target, set|
                  module_target.target_platforms.each do |target_platform|
                    set.add target_platform.platform
                  end
                end
              end

              let(:extra_platform) do
                extra_platforms.sample
              end

              let(:extra_platforms) do
                platform_class.all - expected_platform_set.to_a
              end

              let(:human_platform_set) do
                "{#{extra_platform.fully_qualified_name}}"
              end

              #
              # Callbacks
              #

              before(:each) do
                module_instance.module_platforms <<  FactoryGirl.build(
                    module_platform_factory,
                    platform: extra_platform,
                    module_instance: module_instance
                )

                module_instance.valid?
              end

              it 'includes extra error' do
                expect(platforms_errors).to include(error)
              end
            end

            context 'with missing platforms' do
              #
              # Lets
              #

              let(:error) do
                I18n.translate(
                    'metasploit.model.errors.models.metasploit/model/module/instance.attributes.platforms.missing',
                    missing: human_platform_set
                )
              end

              let(:human_platform_set) do
                "{#{missing_platform.fully_qualified_name}}"
              end

              let(:missing_platform) do
                missing_module_platform.platform
              end

              let(:missing_module_platform) do
                module_instance.module_platforms.sample
              end

              #
              # Callbacks
              #

              before(:each) do
                module_instance.module_platforms.reject! { |module_platform|
                  module_platform == missing_module_platform
                }

                module_instance.valid?
              end

              it 'includes missing error' do
                expect(platforms_errors).to include(error)
              end
            end
          end
        end
      end
    end
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