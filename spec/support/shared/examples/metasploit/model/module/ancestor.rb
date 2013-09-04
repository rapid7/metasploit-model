shared_examples_for 'Metasploit::Model::Module::Ancestor' do
  it_should_behave_like 'Metasploit::Model::RealPathname' do
    let(:base_instance) do
      FactoryGirl.build(ancestor_factory)
    end
  end

  context 'CONSTANTS' do
    context 'DIRECTORY_BY_MODULE_TYPE' do
      subject(:directory_by_module_type) do
        described_class::DIRECTORY_BY_MODULE_TYPE
      end

      its(['auxiliary']) { should == 'auxiliary' }
      its(['encoder']) { should == 'encoders' }
      its(['exploit']) { should == 'exploits' }
      its(['nop']) { should == 'nops' }
      its(['payload']) { should == 'payloads' }
      its(['post']) { should == 'post' }

      it 'should have same module types as Metasploit::Model::Module::Type::ALL' do
        directory_by_module_type.keys.should =~ Metasploit::Model::Module::Type::ALL
      end
    end

    context 'EXTENSION' do
      subject(:extension) do
        described_class::EXTENSION
      end

      it 'should be ruby source extension' do
        extension.should == '.rb'
      end

      it "should start with '.'" do
        extension.should start_with('.')
      end
    end

    context 'HANDLED_TYPES' do
      subject(:handled_types) do
        described_class::HANDLED_TYPES
      end

      it { should include('single') }
      it { should_not include('stage') }
      it { should include('stager') }

      it 'should be a subset of PAYLOAD_TYPES' do
        handled_type_set = Set.new(handled_types)
        payload_type_set = Set.new(described_class::PAYLOAD_TYPES)

        handled_type_set.should be_a_subset(payload_type_set)
      end
    end

    context 'MODULE_TYPE_BY_DIRECTORY' do
      subject(:module_type_by_directory) do
        described_class::MODULE_TYPE_BY_DIRECTORY
      end

      its(['auxiliary']) { should == 'auxiliary' }
      its(['encoders']) { should == 'encoder' }
      its(['exploits']) { should == 'exploit' }
      its(['nops']) { should == 'nop' }
      its(['payloads']) { should == 'payload' }
      its(['post']) { should == 'post' }

      it 'should have same module types as Metasploit::Model::Module::Type::ALL' do
        module_type_by_directory.values.should =~ Metasploit::Model::Module::Type::ALL
      end
    end

    context 'PAYLOAD_TYPES' do
      subject(:payload_types) do
        described_class::PAYLOAD_TYPES
      end

      it { should include('single') }
      it { should include('stage') }
      it { should include('stager') }
    end

    # pattern is tested in validation tests below
    it 'should define REFERENCE_NAME_REGEXP' do
      described_class::REFERENCE_NAME_REGEXP.should be_a Regexp
    end

    context 'REFERENCE_NAME_SEPARATOR' do
      subject(:reference_name_separator) do
        described_class::REFERENCE_NAME_SEPARATOR
      end

      it { should == '/' }
    end

    # pattern is tested in validation tests below
    it 'should define SHA_HEX_DIGEST_REGEXP' do
      described_class::SHA1_HEX_DIGEST_REGEXP.should be_a Regexp
    end
  end

  context 'derivation' do
    def attribute_type(attribute)
      type_by_attribute = {
          :full_name => :text,
          :module_type => :string,
          :payload_type => :string,
          :real_path => :text,
          :real_path_modified_at => :datetime,
          :real_path_sha1_hex_digest => :string,
          :reference_name => :text
      }

      type_by_attribute.fetch(attribute)
    end

    let(:base_class) do
      ancestor_class
    end

    it_should_behave_like 'derives', :full_name, :validates => true
    it_should_behave_like 'derives', :real_path, :validates => true

    context 'with payload' do
      subject(:ancestor) do
        FactoryGirl.build(
            ancestor_factory,
            # {Mdm::Module::Ancestor#derived_payload_type} will be `nil` unless {Mdm::Module::Ancestor#module_type} is
            # `'payload'`
            :module_type => 'payload',
            # Ensure {Mdm::Module::Ancestor#derived_payload} will be a valid {Mdm::Module::Ancestor#payload_type}.
            :reference_name => reference_name
        )
      end

      let(:reference_name) do
        FactoryGirl.generate :metasploit_model_module_ancestor_payload_reference_name
      end

      it_should_behave_like 'derives', :payload_type, :validates => true
    end

    context 'with real_path' do
      before(:each) do
        # {Metasploit::Model::Module::Ancestor#derived_real_path_modified_at} and
        # {Metasploit::Model::Module::Ancestor#derived_real_path_sha1_hex_digest} both depend on real_path being
        # populated or they will return nil, so need set real_path = derived_real_path before testing as would happen
        # with the normal order of before validation callbacks.
        ancestor.real_path = ancestor.derived_real_path

        # blank out {Metasploit::Model::Module::Ancestor#module_type} and
        # {Metasploit::Model::Module::Ancestor#reference_name} so they will be rederived from
        # {Metasploit::Model::Module::Ancestor#real_path} to simulate module cache construction usage.
        ancestor.module_type = nil
        ancestor.reference_name = nil
      end

      it_should_behave_like 'derives', :module_type, :validates => false
      it_should_behave_like 'derives', :real_path_modified_at, :validates => false
      it_should_behave_like 'derives', :real_path_sha1_hex_digest, :validates => false
      it_should_behave_like 'derives', :reference_name, :validates => false
    end
  end

  context 'mass assignment security' do
    it 'should not allow mass assignment of full_name since it must match derived_full_name' do
      ancestor.should_not allow_mass_assignment_of(:full_name)
    end

    it { should allow_mass_assignment_of(:handler_type) }
    it { should allow_mass_assignment_of(:module_type) }

    it 'should not allow mass assignment of payload_type since it must match derived_payload_type' do
      ancestor.should_not allow_mass_assignment_of(:payload_type)
    end

    it 'should not allow mass assignment of real_path since it must match derived_real_path' do
      ancestor.should_not allow_mass_assignment_of(:real_path)
    end

    it 'should not allow mass assignment of real_path_modified_at since it is derived' do
      ancestor.should_not allow_mass_assignment_of(:real_path_modified_at)
    end

    it 'should not allow mass assignment of real_path_sha1_hex_digest since it is derived' do
      ancestor.should_not allow_mass_assignment_of(:real_path_sha1_hex_digest)
    end

    it { should_not allow_mass_assignment_of(:parent_path_id) }
  end

  context 'validations' do
    subject(:ancestor) do
      # Don't use factory so that nil values can be tested without the nil being replaced with derived value
      ancestor_class.new
    end

    context 'handler_type' do
      subject(:ancestor) do
        FactoryGirl.build(
            ancestor_factory,
            :handler_type => handler_type,
            :module_type => module_type,
            :payload_type => payload_type
        )
      end

      context 'with payload' do
        let(:module_type) do
          'payload'
        end

        context 'with payload_type' do
          context 'single' do
            let(:payload_type) do
              'single'
            end

            context 'with handler_type' do
              let(:handler_type) do
                FactoryGirl.generate :metasploit_model_module_ancestor_handler_type
              end

              it { should be_valid }
            end

            context 'without handler_type' do
              let(:handler_type) do
                nil
              end

              it { should_not be_valid }

              it 'should record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should include("can't be blank")
              end
            end
          end

          context 'stage' do
            let(:payload_type) do
              'stage'
            end

            context 'with handler_type' do
              let(:handler_type) do
                FactoryGirl.generate :metasploit_model_module_ancestor_handler_type
              end

              it { should_not be_valid }

              it 'should record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should include('must be nil')
              end
            end

            context 'without handler_type' do
              let(:handler_type) do
                nil
              end

              it { should be_valid }
            end
          end

          context 'stager' do
            let(:payload_type) do
              'stager'
            end

            context 'with handler_type' do
              let(:handler_type) do
                FactoryGirl.generate :metasploit_model_module_ancestor_handler_type
              end

              it { should be_valid }
            end

            context 'without handler_type' do
              let(:handler_type) do
                nil
              end

              it { should_not be_valid }

              it 'should record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should include("can't be blank")
              end
            end
          end
        end
      end

      context 'without payload' do
        let(:module_type) do
          FactoryGirl.generate :metasploit_model_non_payload_module_type
        end

        context 'with payload_type' do
          # force payload_type to NOT be derived to check invalid setups
          before(:each) do
            ancestor.payload_type = payload_type
          end

          context 'single' do
            let(:payload_type) do
              'single'
            end

            context 'with handler_type' do
              let(:handler_type) do
                FactoryGirl.generate :metasploit_model_module_ancestor_handler_type
              end

              it { should be_invalid }

              it 'should record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should include('must be nil')
              end
            end

            context 'without handler_type' do
              let(:handler_type) do
                nil
              end

              it 'should not record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should be_empty
              end
            end
          end

          context 'stage' do
            let(:payload_type) do
              'stage'
            end

            context 'with handler_type' do
              let(:handler_type) do
                FactoryGirl.generate :metasploit_model_module_ancestor_handler_type
              end

              it { should_not be_valid }

              it 'should record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should include('must be nil')
              end
            end

            context 'without handler_type' do
              let(:handler_type) do
                nil
              end

              it 'should not record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should be_empty
              end
            end
          end

          context 'stager' do
            let(:payload_type) do
              'stager'
            end

            context 'with handler_type' do
              let(:handler_type) do
                FactoryGirl.generate :metasploit_model_module_ancestor_handler_type
              end

              it { should_not be_valid }

              it 'should record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should include('must be nil')
              end
            end

            context 'without handler_type' do
              let(:handler_type) do
                nil
              end

              it 'should not record error on handler_type' do
                ancestor.valid?

                ancestor.errors[:handler_type].should be_empty
              end
            end
          end
        end

        context 'without payload_type' do
          let(:payload_type) do
            nil
          end

          context 'with handler_type' do
            let(:handler_type) do
              FactoryGirl.generate :metasploit_model_module_ancestor_handler_type
            end

            it { should_not be_valid }

            it 'should record error on handler_type' do
              ancestor.valid?

              ancestor.errors[:handler_type].should include('must be nil')
            end
          end

          context 'without handler_type' do
            let(:handler_type) do
              nil
            end

            it { should be_valid }
          end
        end
      end
    end

    it { should ensure_inclusion_of(:module_type).in_array(Metasploit::Model::Module::Type::ALL) }
    it { should validate_presence_of(:parent_path) }

    context 'payload_type' do
      subject(:ancestor) do
        FactoryGirl.build(
            ancestor_factory,
            :module_type => module_type,
            :reference_name => reference_name
        )
      end

      before(:each) do
        # payload is ignored in metasploit_model_module_ancestor trait so need set it directly
        ancestor.payload_type = payload_type
      end

      context 'with payload?' do
        let(:module_type) do
          'payload'
        end

        context 'with payload_type' do
          Metasploit::Model::Module::Ancestor::PAYLOAD_TYPES.each do |allowed_payload_type|
            context "with #{allowed_payload_type}" do
              let(:payload_type) do
                nil
              end

              let(:payload_type_directory) do
                allowed_payload_type.pluralize
              end

              let(:reference_name) do
                "#{payload_type_directory}/name"
              end

              it { should be_valid }
            end
          end
        end

        context 'without payload_type' do
          let(:payload_type) do
            nil
          end

          let(:reference_name) do
            FactoryGirl.generate :metasploit_model_module_ancestor_non_payload_reference_name
          end

          it { should_not be_valid }

          it 'should record error on payload_type' do
            ancestor.valid?

            ancestor.errors[:payload_type].should include('is not included in the list')
          end
        end
      end

      context 'without payload?' do
        let(:module_type) do
          FactoryGirl.generate :metasploit_model_non_payload_module_type
        end

        context 'with payload_type' do
          # force payload to not be nil so that derive_payload_type is not called.
          let(:payload_type) do
            FactoryGirl.generate :metasploit_model_module_ancestor_payload_type
          end

          let(:reference_name) do
            "#{payload_type.pluralize}/name"
          end

          it { should_not be_valid }

          it 'should record error on payload_type' do
            ancestor.valid?

            ancestor.errors[:payload_type].should include('must be nil')
          end
        end

        context 'without payload_type' do
          let(:payload_type) do
            nil
          end

          let(:reference_name) do
            FactoryGirl.generate :metasploit_model_module_ancestor_non_payload_reference_name
          end

          it { should be_valid }
        end
      end
    end

    it { should validate_presence_of(:real_path_modified_at) }

    context 'real_path_sha1_hex_digest' do
      context 'validates format with SHA1_HEX_DIGEST_REGEXP' do
        let(:hexdigest) do
          Digest::SHA1.hexdigest('')
        end

        it 'should allow a Digest::SHA1.hexdigest' do
          ancestor.should allow_value(hexdigest).for(:real_path_sha1_hex_digest)
        end

        it 'should not allow a truncated Digest::SHA1.hexdigest' do
          ancestor.should_not allow_value(hexdigest[0, 39]).for(:real_path_sha1_hex_digest)
        end

        it 'should not allow upper case hex to maintain normalization' do
          ancestor.should_not allow_value(hexdigest.upcase).for(:real_path_sha1_hex_digest)
        end

        it { should_not allow_value(nil).for(:real_path_sha1_hex_digest) }
      end
    end

    context 'reference_name' do
      context 'validates format with REFERENCE_NAME_REGEXP' do
        context 'without slashes' do
          context 'first character' do
            it 'should allow lowercase letter' do
              ancestor.should allow_value('a').for(:reference_name)
            end

            it 'should not allow uppercase letter' do
              ancestor.should_not allow_value('A').for(:reference_name)
            end

            it 'should not allow digit' do
              ancestor.should_not allow_value('9').for(:reference_name)
            end

            it 'should not allow underscore' do
              ancestor.should_not allow_value('_').for(:reference_name)
            end
          end

          context 'later letters' do
            let(:lowercase_letters) do
              ('a'..'z').to_a
            end

            let(:first_letter) do
              lowercase_letters.sample
            end

            it 'should allow lowercase letter' do
              ancestor.should allow_value("#{first_letter}a").for(:reference_name)
            end

            it 'should not allow uppercase letter' do
              ancestor.should_not allow_value("#{first_letter}A").for(:reference_name)
            end

            it 'should allow digit' do
              ancestor.should allow_value("#{first_letter}1").for(:reference_name)
            end

            it 'should allow underscore' do
              ancestor.should allow_value("#{first_letter}_").for(:reference_name)
            end
          end
        end

        context 'with slashes' do
          let(:section) do
            "a_1"
          end

          context 'leading' do
            it "should not allow '/'" do
              ancestor.should_not allow_value("/#{section}").for(:reference_name)
            end

            it "should not allow '\\'" do
              ancestor.should_not allow_value("\\#{section}").for(:reference_name)
            end
          end

          context 'infix' do
            it "should allow '/'" do
              ancestor.should allow_value("#{section}/#{section}").for(:reference_name)
            end

            it "should not allow '\\'" do
              ancestor.should_not allow_value("#{section}\\#{section}").for(:reference_name)
            end
          end

          context 'trailing' do
            it "should not allow '/'" do
              ancestor.should_not allow_value("#{section}/").for(:reference_name)
            end

            it "should not allow '\\'" do
              ancestor.should_not allow_value("#{section}\\").for(:reference_name)
            end
          end
        end
      end
    end
  end

  context '#derived_full_name' do
    subject(:derived_full_name) do
      ancestor.derived_full_name
    end

    let(:ancestor) do
      FactoryGirl.build(
          ancestor_factory,
          :module_type => module_type,
          # don't create parent_path since it's unneeded for tests
          :parent_path => nil
      )
    end

    context 'with module_type' do
      let(:module_type) do
        FactoryGirl.generate :metasploit_model_module_type
      end

      it "should equal <module_type>/<reference_name>" do
        derived_full_name.should == "#{ancestor.module_type}/#{ancestor.reference_name}"
      end
    end

    context 'without module_type' do
      let(:module_type) do
        nil
      end

      it { should be_nil }
    end
  end

  context '#derived_module_type' do
    subject(:derived_module_type) do
      ancestor.derived_module_type
    end

    before(:each) do
      ancestor.real_path = real_path
    end

    context 'with #real_path' do
      let(:real_path) do
        ancestor.derived_real_path
      end

      before(:each) do
        ancestor.parent_path = module_path
      end

      context 'with Metasploit::Model::Module::Path' do
        let(:module_path) do
          ancestor.parent_path
        end

        before(:each) do
          module_path.real_path = module_path_real_path
        end

        context 'with Metasploit::Model::Module::Path#real_path' do
          let(:module_path_real_path) do
            module_path.real_path
          end

          it { should_not be_nil }
        end

        context 'without Metasploit::Model::Module::Path#real_path' do
          let(:module_path_real_path) do
            nil
          end

          it { should be_nil }
        end
      end

      context 'without Metasploit::Model::Module::Path' do
        let(:module_path) do
          nil
        end

        it { should be_nil }
      end
    end

    context 'without #real_path' do
      let(:real_path) do
        nil
      end

      it { should be_nil }
    end
  end

  context '#derived_payload_type' do
    subject(:derived_payload_type) do
      ancestor.derived_payload_type
    end

    let(:ancestor) do
      FactoryGirl.build(
          ancestor_factory,
          :module_type => module_type
      )
    end

    context 'with payload' do
      let(:module_type) do
        'payload'
      end

      it 'should singularize payload_type_directory' do
        derived_payload_type.should == ancestor.payload_type_directory.singularize
      end
    end

    context 'without payload' do
      let(:module_type) do
        FactoryGirl.generate :metasploit_model_non_payload_module_type
      end

      it { should be_nil }
    end
  end

  context '#derived_real_path' do
    subject(:derived_real_path) do
      ancestor.derived_real_path
    end

    let(:ancestor) do
      FactoryGirl.build(
          ancestor_factory,
          :module_type => module_type,
          :parent_path => parent_path,
          :reference_name => reference_name
      )
    end

    let(:module_type) do
      nil
    end

    let(:parent_path) do
      nil
    end

    let(:reference_name) do
      nil
    end

    context 'with parent_path' do
      let(:parent_path) do
        FactoryGirl.build(
            path_factory,
            :real_path => parent_path_real_path
        )
      end

      context 'with parent_path.real_path' do
        let(:parent_path_real_path) do
          FactoryGirl.generate :metasploit_model_module_path_real_path
        end

        context 'with module_type' do
          let(:module_type) do
            FactoryGirl.generate :metasploit_model_module_type
          end

          context 'with reference_name' do
            let(:reference_name) do
              FactoryGirl.generate :metasploit_model_module_ancestor_non_payload_reference_name
            end

            it 'should be full path including parent_path.real_path, type_directory, and reference_path' do
              derived_real_path.should == File.join(
                  parent_path_real_path,
                  ancestor.module_type_directory,
                  ancestor.reference_path
              )
            end
          end

          context 'without reference_name' do
            let(:reference_name) do
              nil
            end

            it { should be_nil }
          end
        end

        context 'without module_type' do
          let(:module_type) do
            nil
          end

          it { should be_nil }
        end
      end

      context 'without parent_path.real_path' do
        let(:parent_path_real_path) do
          nil
        end

        it { should be_nil }
      end
    end

    context 'without parent_path' do
      let(:parent_path) do
        nil
      end

      it { should be_nil }
    end
  end

  context '#derived_real_path_modified_at' do
    subject(:derived_real_path_modified_at) do
      ancestor.derived_real_path_modified_at
    end

    let(:ancestor) do
      FactoryGirl.build(ancestor_factory)
    end

    context 'with real_path' do
      before(:each) do
        ancestor.real_path = real_path
      end

      context 'that exists' do
        let(:real_path) do
          # derived real path will have been created by factory's after(:build)
          ancestor.derived_real_path
        end

        it 'should be modification time of file' do
          derived_real_path_modified_at.should == File.mtime(real_path)
        end

        it 'should be in UTC' do
          derived_real_path_modified_at.zone.should == 'UTC'
        end
      end

      context 'that does not exist' do
        let(:real_path) do
          'non/existent/path'
        end

        it { should be_nil }
      end
    end

    context 'without real_path' do
      it 'should have nil for real_path' do
        ancestor.real_path.should be_nil
      end

      it { should be_nil }
    end
  end

  context '#derived_real_path_sha1_hex_digest' do
    subject(:derived_real_path_sha1_hex_digest) do
      ancestor.derived_real_path_sha1_hex_digest
    end

    let(:ancestor) do
      FactoryGirl.build(ancestor_factory)
    end

    context 'with real_path' do
      before(:each) do
        ancestor.real_path = ancestor.derived_real_path
      end

      context 'that exists' do
        it 'should read the using Digest::SHA1.file' do
          Digest::SHA1.should_receive(:file).with(ancestor.real_path).and_call_original

          derived_real_path_sha1_hex_digest
        end

        context 'with content' do
          let(:content_sha1_hex_digest) do
            Digest::SHA1.hexdigest(content)
          end

          before(:each) do
            File.open(ancestor.real_path, 'wb') do |f|
              f.write(content)
            end
          end

          context 'that is empty' do
            let(:content) do
              ''
            end

            it 'should have empty file at real_path' do
              File.size(ancestor.real_path).should be_zero
            end

            it 'should have SHA1 hex digest for empty string' do
              derived_real_path_sha1_hex_digest.should == content_sha1_hex_digest
            end
          end

          context 'that is not empty' do
            let(:content) do
              "# Non-empty content"
            end

            it 'should have SHA1 hex digest for content' do
              derived_real_path_sha1_hex_digest.should == content_sha1_hex_digest
            end
          end
        end
      end

      context 'that does not exist' do
        before(:each) do
          File.delete(ancestor.real_path)
        end

        it { should be_nil }
      end
    end

    context 'without real_path' do
      it 'should have nil for real_path' do
        ancestor.real_path.should be_nil
      end

      it { should be_nil }
    end
  end

  context '#derived_reference_name' do
    subject(:derived_reference_name) do
      ancestor.derived_reference_name
    end

    before(:each) do
      ancestor.stub(relative_file_names: relative_file_names)
    end

    context 'with empty #relative_file_names' do
      let(:relative_file_names) do
        Enumerator.new { }
      end

      it { should be_nil }
    end

    context 'without empty #relative_file_names' do
      context 'with one element' do
        let(:relative_file_names) do
          ['a'].each
        end
      end

      context 'with more than one element' do
        context 'with EXTENSION' do
          let(:relative_file_names) do
            ['a', 'b', "c#{described_class::EXTENSION}"].each
          end

          it 'should not include first file name' do
            derived_reference_name.split(described_class::REFERENCE_NAME_SEPARATOR).should_not include('a')
          end

          it 'should match REFERENCE_NAME_REGEXP' do
            derived_reference_name.should match(described_class::REFERENCE_NAME_REGEXP)
          end

          it 'should not include EXTENSION' do
            derived_reference_name.should_not end_with(described_class::EXTENSION)
          end

          it 'should be all file names except the first joined with the REFERENCE_NAME_SEPARATOR with EXTENSION' do
            derived_reference_name.should == "b#{described_class::REFERENCE_NAME_SEPARATOR}c"
          end
        end

        context 'without EXTENSION' do
          let(:relative_file_names) do
            ['a', 'b', 'c'].each
          end

          it { should be_nil }
        end
      end
    end
  end

  # class method
  context 'handled?' do
    subject(:handled?) do
      ancestor_class.handled?(
          :module_type => module_type,
          :payload_type => payload_type
      )
    end

    context 'with module_type' do
      context 'payload' do
        let(:module_type) do
          'payload'
        end

        context 'with payload_type' do
          context 'single' do
            let(:payload_type) do
              'single'
            end

            it { should be_true }
          end

          context 'stage' do
            let(:payload_type) do
              'stage'
            end

            it { should be_false }
          end

          context 'stager' do
            let(:payload_type) do
              'stager'
            end

            it { should be_true }
          end
        end

        context 'without payload_type' do
          let(:payload_type) do
            nil
          end

          it { should be_false }
        end
      end

      context 'non-payload' do
        let(:module_type) do
          FactoryGirl.generate :metasploit_model_non_payload_module_type
        end

        context 'with payload_type' do
          context 'single' do
            let(:payload_type) do
              'single'
            end

            it { should be_false }
          end

          context 'stage' do
            let(:payload_type) do
              'stage'
            end

            it { should be_false }
          end

          context 'stager' do
            let(:payload_type) do
              'stager'
            end

            it { should be_false }
          end
        end

        context 'without payload_type' do
          let(:payload_type) do
            nil
          end

          it { should be_false }
        end
      end
    end

    context 'without module_type' do
      let(:module_type) do
        nil
      end

      context 'with payload_type' do
        context 'single'  do
          let(:payload_type) do
            'single'
          end

          it { should be_false }
        end

        context 'stage' do
          let(:payload_type) do
            'stage'
          end

          it { should be_false }
        end

        context 'stager' do
          let(:payload_type) do
            'stager'
          end

          it { should be_false }
        end
      end

      context 'without payload_type' do
        let(:payload_type) do
          nil
        end

        it { should be_false }
      end
    end
  end

  # instance method
  context '#handled?' do
    subject(:handled?) do
      ancestor.handled?
    end

    let(:ancestor) do
      FactoryGirl.build(
          ancestor_factory,
          :module_type => module_type,
          :payload_type => payload_type
      )
    end

    let(:module_type) do
      'payload'
    end

    let(:payload_type) do
      FactoryGirl.generate :metasploit_model_module_ancestor_payload_type
    end

    before(:each) do
      ancestor.payload_type = ancestor.derived_payload_type
    end

    it 'should delegate to class method' do
      ancestor_class.should_receive(:handled?).with(
          :module_type => module_type,
          :payload_type => payload_type
      )

      handled?
    end
  end

  context '#payload?' do
    subject(:ancestor) do
      ancestor_class.new(:module_type => module_type)
    end

    context "with 'payload' module_type" do
      let(:module_type) do
        'payload'
      end

      it { should be_payload }
    end

    context "without 'payload' module_type" do
      let(:module_type) do
        FactoryGirl.generate :metasploit_model_non_payload_module_type
      end

      it { should_not be_payload }
    end
  end

  context '#relative_file_names' do
    subject(:relative_file_names) do
      ancestor.relative_file_names
    end

    before(:each) do
      ancestor.stub(relative_pathname: relative_pathname)
    end

    context 'with #relative_pathnames' do
      let(:file_names) do
        [
            'a',
            'b',
            'c'
        ]
      end

      let(:relative_pathname) do
        Pathname.new(file_names.join('/'))
      end

      it { should be_an Enumerator }

      it 'should include all file names, in order' do
        relative_file_names.to_a.should == file_names
      end
    end

    context 'without #relative_pathnames' do
      let(:relative_pathname) do
        nil
      end

      it { should be_an Enumerator }
      its(:to_a) { should be_empty }
    end
  end

  context '#relative_pathname' do
    subject(:relative_pathname) do
      ancestor.relative_pathname
    end

    before(:each) do
      ancestor.stub(real_pathname: real_pathname)
    end

    context 'with #real_pathname' do
      let(:real_pathname) do
        Pathname.new('a/b/c')
      end

      before(:each) do
        ancestor.parent_path = parent_path
      end

      context 'with #parent_path' do
        let(:parent_path) do
          ancestor.parent_path
        end

        before(:each) do
          parent_path.stub(real_pathname: parent_path_real_pathname)
        end

        context 'with Metasploit::Model::Module::Path#real_pathname' do
          let(:parent_path_real_pathname) do
            Pathname.new('a')
          end

          it { should be_a Pathname }
          it { should be_relative }

          it 'should be relative to parent_path.real_pathname' do
            relative_pathname.should == Pathname.new('b/c')
          end
        end

        context 'without Metasploit::Model::Module::Path#real_pathname' do
          let(:parent_path_real_pathname) do
            nil
          end

          it { should be_nil }
        end
      end

      context 'without #parent_path' do
        let(:parent_path) do
          nil
        end

        it { should be_nil }
      end
    end

    context 'without #real_pathname' do
      let(:real_pathname) do
        nil
      end

      it { should be_nil }
    end
  end

  context '#reference_path' do
    subject(:reference_path) do
      ancestor.reference_path
    end

    let(:ancestor) do
      ancestor_class.new(
          :reference_name => reference_name
      )
    end

    context 'with reference_name' do
      let(:reference_name) do
        FactoryGirl.generate :metasploit_model_module_ancestor_non_payload_reference_name
      end

      it 'should be reference_name + EXTENSION' do
        reference_path.should == "#{reference_name}#{Metasploit::Model::Module::Ancestor::EXTENSION}"
      end
    end

    context 'without reference_name' do
      let(:reference_name) do
        nil
      end

      it { should be_nil }
    end
  end

  context '#module_type_directory' do
    subject(:module_type_directory) do
      ancestor.module_type_directory
    end

    let(:ancestor) do
      ancestor_class.new(
          :module_type => module_type
      )
    end

    context 'with module_type' do
      context 'in known types' do
        let(:module_type) do
          FactoryGirl.generate :metasploit_model_module_type
        end

        it 'should use Metasploit::Model::Module::Ancestor::DIRECTORY_BY_MODULE_TYPE' do
          module_type_directory.should == Metasploit::Model::Module::Ancestor::DIRECTORY_BY_MODULE_TYPE[module_type]
        end
      end

      context 'in unknown types' do
        let(:module_type) do
          'not_a_type'
        end

        it { should be_nil }
      end
    end

    context 'without module_type' do
      let(:module_type) do
        nil
      end

      it { should be_nil }
    end
  end
end