Metasploit::Model::Spec.shared_examples_for 'Module::Path' do
  named_module_path_factory = "named_#{module_path_factory}"
  unnamed_module_path_factory = "un#{named_module_path_factory}"

  it { should be_a ActiveModel::Dirty }

  it_should_behave_like 'Metasploit::Model::RealPathname' do
    let(:base_instance) do
      FactoryGirl.build(module_path_factory)
    end
  end

  context 'callbacks' do
    context 'before_validation' do
      context 'nilify blanks' do
        let(:path) do
          FactoryGirl.build(
              module_path_factory,
              :gem => '',
              :name => ''
          )
        end

        it 'should have empty gem' do
          path.gem.should_not be_nil
          path.gem.should be_empty
        end

        it 'should have empty name' do
          path.name.should_not be_nil
          path.name.should be_empty
        end

        context 'after validation' do
          before(:each) do
            path.valid?
          end

          its(:gem) { should be_nil }
          its(:name) { should be_nil }
        end
      end

      context '#normalize_real_path' do
        let(:parent_pathname) do
          Metasploit::Model::Spec.temporary_pathname.join('metasploit', 'model', 'module', 'path')
        end

        let(:path) do
          FactoryGirl.build(
              module_path_factory,
              :real_path => symlink_pathname.to_path
          )
        end

        let(:real_basename) do
          'real'
        end

        let(:real_pathname) do
          parent_pathname.join(real_basename)
        end

        let(:symlink_basename) do
          'symlink'
        end

        let(:symlink_pathname) do
          parent_pathname.join(symlink_basename)
        end

        before(:each) do
          real_pathname.mkpath

          Dir.chdir(parent_pathname.to_path) do
            File.symlink(real_basename, 'symlink')
          end
        end

        it 'should convert real_path to a real path using File#real_path' do
          expected_real_path = Metasploit::Model::File.realpath(path.real_path)

          path.real_path.should_not == expected_real_path

          path.valid?

          path.real_path.should == expected_real_path
        end
      end
    end
  end

  context 'factories' do
    context module_path_factory do
      subject(module_path_factory) do
        FactoryGirl.build(module_path_factory)
      end

      it { should be_valid }
    end

    context named_module_path_factory do
      subject(named_module_path_factory) do
        FactoryGirl.build(named_module_path_factory)
      end

      it { should be_valid }

      its(:gem) { should_not be_nil }
      its(:name) { should_not be_nil }
    end

    context unnamed_module_path_factory do
      subject(unnamed_module_path_factory) do
        FactoryGirl.build(unnamed_module_path_factory)
      end

      it { should be_valid }

      its(:gem) { should be_nil }
      its(:name) { should be_nil }
    end
  end

  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:gem) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:real_path) }
  end

  context 'validations' do
    context 'directory' do
      let(:error) do
        'must be a directory'
      end

      let(:path) do
        FactoryGirl.build(
            module_path_factory,
            :real_path => real_path
        )
      end

      before(:each) do
        path.valid?
      end

      context 'with #real_path' do
        context 'with directory' do
          let(:real_path) do
            FactoryGirl.generate :metasploit_model_module_path_directory_real_path
          end

          it 'should not record error on real_path' do
            path.valid?

            path.errors[:real_path].should_not include(error)
          end
        end

        context 'with file' do
          let(:pathname) do
            Metasploit::Model::Spec.temporary_pathname.join(
                'metasploit',
                'model',
                'module',
                'path',
                'real',
                'path',
                'file'
            )
          end

          let(:real_path) do
            pathname.to_path
          end

          before(:each) do
            Metasploit::Model::Spec::PathnameCollision.check!(pathname)

            pathname.parent.mkpath

            pathname.open('wb') do |f|
              f.puts 'A file'
            end
          end

          it 'should record error on real_path' do
            path.valid?

            path.errors[:real_path].should include(error)
          end
        end
      end

      context 'without #real_path' do
        let(:real_path) do
          nil
        end

        it 'should record error on real_path' do
          path.valid?

          path.errors[:real_path].should include(error)
        end
      end
    end

    context 'gem and name' do
      let(:gem_error) do
        "can't be blank if name is present"
      end

      let(:name_error) do
        "can't be blank if gem is present"
      end

      subject(:path) do
        FactoryGirl.build(
            module_path_factory,
            :gem => gem,
            :name => name
        )
      end

      before(:each) do
        path.valid?
      end

      context 'with gem' do
        let(:gem) do
          FactoryGirl.generate :metasploit_model_module_path_gem
        end

        context 'with name' do
          let(:name) do
            FactoryGirl.generate :metasploit_model_module_path_name
          end

          it 'should not record error on gem' do
            path.errors[:gem].should_not include(gem_error)
          end

          it 'should not record error on name' do
            path.errors[:name].should_not include(name_error)
          end
        end

        context 'without name' do
          let(:name) do
            nil
          end

          it 'should not record error on gem' do
            path.errors[:gem].should_not include(gem_error)
          end

          it 'should record error on name' do
            path.errors[:name].should include(name_error)
          end
        end
      end

      context 'without gem' do
        let(:gem) do
          nil
        end

        context 'with name' do
          let(:name) do
            FactoryGirl.generate :metasploit_model_module_path_name
          end

          it 'should record error on gem' do
            path.errors[:gem].should include(gem_error)
          end

          it 'should not record error on name' do
            path.errors[:name].should_not include(name_error)
          end
        end

        context 'without name' do
          let(:name) do
            nil
          end

          it 'should not record error on gem' do
            path.errors[:gem].should_not include(gem_error)
          end

          it 'should not record error on name' do
            path.errors[:name].should_not include(name_error)
          end
        end
      end
    end
  end

  context '#directory?' do
    subject(:directory?) do
      path.directory?
    end

    let(:path) do
      FactoryGirl.build(
          module_path_factory,
          :real_path => real_path
      )
    end

    context 'with #real_path' do
      context 'with file' do
        let(:pathname) do
          Metasploit::Model::Spec.temporary_pathname.join(
              'metasploit',
              'model',
              'module',
              'path',
              'real',
              'path',
              'file'
          )
        end

        let(:real_path) do
          pathname.to_path
        end

        before(:each) do
          Metasploit::Model::Spec::PathnameCollision.check!(pathname)

          pathname.parent.mkpath

          pathname.open('wb') do |f|
            f.puts 'A file'
          end
        end


        it { should be_false }
      end

      context 'with directory' do
        let(:real_path) do
          FactoryGirl.generate :metasploit_model_module_path_directory_real_path
        end

        it { should be_true }
      end
    end

    context 'without #real_path' do
      let(:real_path) do
        nil
      end

      it { should be_false }
    end
  end

  context '#named?' do
    subject(:named?) do
      path.named?
    end

    let(:path) do
      FactoryGirl.build(
          module_path_factory,
          :gem => gem,
          :name => name
      )
    end

    context 'with blank gem' do
      let(:gem) do
        ''
      end

      context 'with blank name' do
        let(:name) do
          ''
        end

        it { should be_false }
      end

      context 'without blank name' do
        let(:name) do
          FactoryGirl.generate :metasploit_model_module_path_name
        end

        it { should be_false }
      end
    end

    context 'without blank gem' do
      let(:gem) do
        FactoryGirl.generate :metasploit_model_module_path_gem
      end

      context 'with blank name' do
        let(:name) do
          ''
        end

        it { should be_false }
      end

      context 'without blank name' do
        let(:name) do
          FactoryGirl.generate :metasploit_model_module_path_name
        end

        it { should be_true }
      end
    end
  end

  context '#was_named?' do
    subject(:was_named?) do
      path.was_named?
    end

    let(:gem) do
      FactoryGirl.generate :metasploit_model_module_path_gem
    end

    let(:name) do
      FactoryGirl.generate :metasploit_model_module_path_name
    end

    let(:path) do
      FactoryGirl.build(
          module_path_factory
      )
    end

    before(:each) do
      path.gem = gem_was
      path.name = name_was

      path.changed_attributes.clear

      path.gem = gem
      path.name = name
    end

    context 'with blank gem_was' do
      let(:gem_was) do
        nil
      end

      context 'with blank name_was' do
        let(:name_was) do
          nil
        end

        it { should be_false }
      end

      context 'without blank name_was' do
        let(:name_was) do
          FactoryGirl.generate :metasploit_model_module_path_name
        end

        it { should be_false }
      end
    end

    context 'without blank gem_was' do
      let(:gem_was) do
        FactoryGirl.generate :metasploit_model_module_path_gem
      end

      context 'with blank name_was' do
        let(:name_was) do
          nil
        end

        it { should be_false }
      end

      context 'without blank name_was' do
        let(:name_was) do
          FactoryGirl.generate :metasploit_model_module_path_name
        end

        it { should be_true }
      end
    end
  end
end