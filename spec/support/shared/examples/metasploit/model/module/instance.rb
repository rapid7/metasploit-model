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

  it_should_behave_like 'Metasploit::Model::Module::Instance::ClassMethods' do
    let(:singleton_class) do
      base_class
    end
  end

  context 'CONSTANTS' do
    context 'DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE' do
      subject(:dynamic_length_validation_options) do
        dynamic_length_validation_options_by_module_type[module_type]
      end

      let(:dynamic_length_validation_options_by_module_type) do
        dynamic_length_validation_options_by_module_type_by_attribute[attribute]
      end

      let(:dynamic_length_validation_options_by_module_type_by_attribute) do
        described_class::DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE
      end

      context "[:actions]" do
        let(:attribute) do
          :actions
        end

        context "['auxiliary']" do
          let(:module_type) do
            'auxiliary'
          end

          its([:minimum]) { should == 0 }
        end

        context "['encoder']" do
          let(:module_type) do
            'encoder'
          end

          its([:is]) { should == 0 }
        end

        context "['exploit']" do
          let(:module_type) do
            'exploit'
          end

          its([:is]) { should == 0 }
        end

        context "['nop']" do
          let(:module_type) do
            'nop'
          end

          its([:is]) { should == 0 }
        end

        context "['payload']" do
          let(:module_type) do
            'payload'
          end

          its([:is]) { should == 0 }
        end

        context "['post']" do
          let(:module_type) do
            'post'
          end

          its([:minimum]) { should == 0 }
        end
      end

      context '[:module_architectures:]' do
        let(:attribute) do
          :module_architectures
        end

        context "['auxiliary']" do
          let(:module_type) do
            'auxiliary'
          end

          its([:is]) { should == 0 }
        end

        context "['encoder']" do
          let(:module_type) do
            'encoder'
          end

          its([:minimum]) { should == 1 }
        end

        context "['exploit']" do
          let(:module_type) do
            'exploit'
          end

          its([:minimum]) { should == 1 }
        end

        context "['nop']" do
          let(:module_type) do
            'nop'
          end

          its([:minimum]) { should == 1 }
        end

        context "['payload']" do
          let(:module_type) do
            'payload'
          end

          its([:minimum]) { should == 1 }
        end

        context "['post']" do
          let(:module_type) do
            'post'
          end

          its([:minimum]) { should == 1 }
        end
      end

      context '[:module_platforms]' do
        let(:attribute) do
          :module_platforms
        end

        context "['auxiliary']" do
          let(:module_type) do
            'auxiliary'
          end

          its([:is]) { should == 0 }
        end

        context "['encoder']" do
          let(:module_type) do
            'encoder'
          end

          its([:is]) { should == 0 }
        end

        context "['exploit']" do
          let(:module_type) do
            'exploit'
          end

          its([:minimum]) { should == 1 }
        end

        context "['nop']" do
          let(:module_type) do
            'nop'
          end

          its([:is]) { should == 0 }
        end

        context "['payload']" do
          let(:module_type) do
            'payload'
          end

          its([:minimum]) { should == 1 }
        end

        context "['post']" do
          let(:module_type) do
            'post'
          end

          its([:minimum]) { should == 1 }
        end
      end

      context '[:module_references]' do
        let(:attribute) do
          :module_references
        end

        context "['auxiliary']" do
          let(:module_type) do
            'auxiliary'
          end

          its([:minimum]) { should == 0 }
        end

        context "['encoder']" do
          let(:module_type) do
            'encoder'
          end

          its([:is]) { should == 0 }
        end

        context "['exploit']" do
          let(:module_type) do
            'exploit'
          end

          its([:minimum]) { should == 1 }
        end

        context "['nop']" do
          let(:module_type) do
            'nop'
          end

          its([:is]) { should == 0 }
        end

        context "['payload']" do
          let(:module_type) do
            'payload'
          end

          its([:is]) { should == 0 }
        end

        context "['post']" do
          let(:module_type) do
            'post'
          end

          its([:minimum]) { should == 0 }
        end
      end

      context '[:targets]' do
        let(:attribute) do
          :targets
        end

        context "['auxiliary']" do
          let(:module_type) do
            'auxiliary'
          end

          its([:is]) { should == 0 }
        end

        context "['encoder']" do
          let(:module_type) do
            'encoder'
          end

          its([:is]) { should == 0 }
        end

        context "['exploit']" do
          let(:module_type) do
            'exploit'
          end

          its([:minimum]) { should == 1 }
        end

        context "['nop']" do
          let(:module_type) do
            'nop'
          end

          its([:is]) { should == 0 }
        end

        context "['payload']" do
          let(:module_type) do
            'payload'
          end

          its([:is]) { should == 0 }
        end

        context "['post']" do
          let(:module_type) do
            'post'
          end

          its([:is]) { should == 0 }
        end
      end
    end

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

          it { should allow_attribute :actions }
          it { should_not allow_attribute :module_architectures }
          it { should_not allow_attribute :module_platforms }
          it { should allow_attribute :module_references }
          it { should_not allow_attribute :targets }

          it { should be_stanced }
        end

        context 'with encoder' do
          let(:module_type) do
            'encoder'
          end

          it { should be_valid }

          it { should_not allow_attribute :actions }
          it { should allow_attribute :module_architectures }
          it { should_not allow_attribute :module_platforms }
          it { should_not allow_attribute :module_references }
          it { should_not allow_attribute :targets }

          it { should_not be_stanced }
        end

        context 'with exploit' do
          let(:module_type) do
            'exploit'
          end

          it { should be_valid }

          it { should_not allow_attribute :actions }
          it { should allow_attribute :module_architectures }
          it { should allow_attribute :module_platforms }
          it { should allow_attribute :module_references }
          it { should allow_attribute :targets }

          it { should be_stanced }
        end

        context 'with nop' do
          let(:module_type) do
            'nop'
          end

          it { should be_valid }

          it { should_not allow_attribute :actions }
          it { should allow_attribute :module_architectures }
          it { should_not allow_attribute :module_platforms }
          it { should_not allow_attribute :module_references }
          it { should_not allow_attribute :targets }

          it { should_not be_stanced }
        end

        context 'with payload' do
          let(:module_type) do
            'payload'
          end

          it { should be_valid }

          it { should_not allow_attribute :actions }
          it { should allow_attribute :module_architectures }
          it { should allow_attribute :module_platforms }
          it { should_not allow_attribute :module_references }
          it { should_not allow_attribute :targets }

          it { should_not be_stanced }
        end

        context 'with post' do
          let(:module_type) do
            'post'
          end

          it { should be_valid }

          it { should allow_attribute :actions }
          it { should allow_attribute :module_architectures }
          it { should allow_attribute :module_platforms }
          it { should allow_attribute :module_references }
          it { should_not allow_attribute :targets }

          it { should_not be_stanced }
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

    it { should validate_presence_of :description }
    it { should validate_presence_of :license }
    it { should ensure_length_of(:module_authors) }

    it_should_behave_like 'Metasploit::Model::Module::Instance validates dynamic length of',
                          :actions,
                          factory: module_action_factory,
                          options_by_extreme_by_module_type: {
                              'auxiliary' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'encoder' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'exploit' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'nop' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'payload' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'post' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              }
                          }

    it_should_behave_like 'Metasploit::Model::Module::Instance validates dynamic length of',
                          :module_architectures,
                          factory: module_architecture_factory,
                          options_by_extreme_by_module_type: {
                              'auxiliary' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'encoder' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              },
                              'exploit' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              },
                              'nop' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              },
                              'payload' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              },
                              'post' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              }
                          }

    it_should_behave_like 'Metasploit::Model::Module::Instance validates dynamic length of',
                          :module_platforms,
                          factory: module_platform_factory,
                          options_by_extreme_by_module_type: {
                              'auxiliary' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'encoder' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'exploit' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              },
                              'nop' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'payload' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              },
                              'post' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              }
                          }

    it_should_behave_like 'Metasploit::Model::Module::Instance validates dynamic length of',
                          :module_references,
                          factory: module_reference_factory,
                          options_by_extreme_by_module_type: {
                              'auxiliary' => {
                                  maximum: {
                                      extreme: Float::INFINITY,
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'encoder' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'exploit' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              },
                              'nop' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'payload' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'post' => {
                                  maximum: {
                                      extreme: Float::INFINITY,
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              }
                          }

    it_should_behave_like 'Metasploit::Model::Module::Instance validates dynamic length of',
                          :targets,
                          factory: module_target_factory,
                          options_by_extreme_by_module_type: {
                              'auxiliary' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'encoder' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'exploit' => {
                                  maximum: {
                                      extreme: Float::INFINITY
                                  },
                                  minimum: {
                                      error_type: :too_short,
                                      extreme: 1
                                  }
                              },
                              'nop' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'payload' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              },
                              'post' => {
                                  maximum: {
                                      error_type: :wrong_length,
                                      extreme: 0
                                  },
                                  minimum: {
                                      extreme: 0
                                  }
                              }
                          }

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

        it_should_behave_like 'Metasploit::Model::Module::Instance is stanced with module_type', 'auxiliary'
        it_should_behave_like 'Metasploit::Model::Module::Instance is stanced with module_type', 'exploit'

        it_should_behave_like 'Metasploit::Model::Module::Instance is not stanced with module_type', 'encoder'
        it_should_behave_like 'Metasploit::Model::Module::Instance is not stanced with module_type', 'nop'
        it_should_behave_like 'Metasploit::Model::Module::Instance is not stanced with module_type', 'payload'
        it_should_behave_like 'Metasploit::Model::Module::Instance is not stanced with module_type', 'post'
      end
    end

    context 'with allows?(:targets)' do
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
        Metasploit::Model::Module::Instance.module_types_that_allow(:targets)
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

  context '#allows?' do
    subject(:allows?) do
      module_instance.allows?(attribute)
    end

    let(:attribute) do
      double('Attribute')
    end

    before(:each) do
      # can't set module_type in module_class factory because module_class would be invalid and not create then
      module_instance.module_class.module_type = module_type
    end

    context 'with valid #module_type' do
      let(:module_type) do
        FactoryGirl.generate :metasploit_model_module_type
      end

      it 'should call allows? on class' do
        # memoize module_instance first so it's calls to allows? do not trigger the should_receive
        module_instance

        base_class.should_receive(:allows?).with(
            hash_including(
                attribute: attribute,
                module_type: module_type
            )
        )

        allows?
      end
    end

    context 'without valid #module_type' do
      let(:module_type) do
        'invalid_module_type'
      end

      it { should be_false }
    end
  end

  context '#dynamic_length_validation_options' do
    subject(:dynamic_length_validation_options) do
      module_instance.dynamic_length_validation_options(attribute)
    end

    let(:attribute) do
      attributes.sample
    end

    let(:attributes) do
      [
          :actions,
          :module_architectures,
          :module_platforms,
          :module_references,
          :targets
      ]
    end

    before(:each) do
      # can't be set on module_class_factory because module_class would fail to create then.
      module_instance.module_class.module_type = module_type
    end

    context 'with valid #module_type' do
      let(:module_type) do
        FactoryGirl.generate :metasploit_model_module_type
      end

      it 'should call dynamic_length_validation_options on class' do
        base_class.should_receive(:dynamic_length_validation_options).with(
            hash_including(
                attribute: attribute,
                module_type: module_type
            )
        )

        dynamic_length_validation_options
      end
    end

    context 'without valid #module_type' do
      let(:module_type) do
        'invalid_module_type'
      end

      it { should == {} }
    end
  end

  context '#module_type' do
    subject(:module_type) do
      module_instance.module_type
    end

    context 'with #module_class' do
      it 'should delegate to #module_type on #module_class' do
        expected_module_type = double('Expected #module_type')
        module_instance.module_class.should_receive(:module_type).and_return(expected_module_type)

        module_type.should == expected_module_type
      end
    end

    context 'without #module_class' do
      before(:each) do
        module_instance.module_class = nil
      end

      it { should be_nil }
    end
  end

  context '#stanced?' do
    subject(:stanced?) do
      module_instance.stanced?
    end

    before(:each) do
      # can't set module_type on module_class factory because it won't pass validations then
      module_instance.module_class.module_type = module_type
    end

    context 'with valid #module_type' do
      let(:module_type) do
        FactoryGirl.generate :metasploit_model_module_type
      end

      it 'should call stanced? on class' do
        base_class.should_receive(:stanced?).with(module_type)

        stanced?
      end
    end

    context 'without valid #module_type' do
      let(:module_type) do
        'invalid_module_type'
      end

      it { should be_false }
    end
  end
end