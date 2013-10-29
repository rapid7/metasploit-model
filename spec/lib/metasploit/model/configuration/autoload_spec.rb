require 'spec_helper'

describe Metasploit::Model::Configuration::Autoload do
  include_context 'Metasploit::Model::Configuration'

  subject(:autoload) do
    described_class.new.tap { |autoload|
      autoload.configuration = configuration
    }
  end

  context 'all_paths' do
    subject(:all_paths) do
      autoload.all_paths
    end

    it 'should include autoload_once_paths' do
      all_paths.to_set.should be_superset(autoload.once_paths.to_set)
    end

    it 'should include paths' do
      all_paths.to_set.should be_superset(autoload.paths.to_set)
    end
  end

  context 'once_paths' do
    subject(:once_paths) do
      autoload.once_paths
    end

    it 'should call relative_once_paths' do
      autoload.should_receive(:relative_once_paths).and_return([])

      once_paths
    end

    it 'should have absolute paths' do
      once_paths.each do |once_path|
        once_path.should == File.absolute_path(once_path)
      end
    end
  end

  context 'paths' do
    subject(:paths) do
      autoload.paths
    end

    it 'should call relative_paths' do
      autoload.should_receive(:relative_paths).and_return([])

      paths
    end

    it 'should have absolute paths' do
      paths.each do |path|
        path.should == File.absolute_path(path)
      end
    end
  end

  context 'relative_once_paths' do
    subject(:relative_once_paths) do
      autoload.relative_once_paths
    end

    it { should include('lib') }
  end

  context 'relative_paths' do
    subject(:relative_paths) do
      autoload.relative_paths
    end

    it { should include('app/models') }
  end

  context 'setup' do
    subject(:setup) do
      autoload.setup
    end

    let(:autoload_once_path) do
      Metasploit::Model.root.join('spec', 'dummy', 'lib').to_path
    end

    let(:autoload_path) do
      Metasploit::Model.root.join('spec', 'dummy', 'app', 'models').to_path
    end

    before(:each) do
      @before_autoload_paths = ActiveSupport::Dependencies.autoload_paths.dup
      ActiveSupport::Dependencies.autoload_paths.clear

      @before_autoload_once_paths = ActiveSupport::Dependencies.autoload_once_paths.dup
      ActiveSupport::Dependencies.autoload_once_paths.clear

      autoload.stub(:autoload_once_paths).and_return([autoload_once_path])
      autoload.stub(:autoload_paths).and_return([])
    end

    after(:each) do
      ActiveSupport::Dependencies.autoload_paths = @before_autoload_paths
      ActiveSupport::Dependencies.autoload_once_paths = @before_autoload_once_paths
    end

    context 'paths' do
      it 'should call all_paths' do
        autoload.should_receive(:all_paths).and_return([])

        setup
      end

      context 'with autoload_path in ActiveSupport::Dependencies.autoload_paths' do
        before(:each) do
          ActiveSupport::Dependencies.autoload_paths << autoload_path
          ActiveSupport::Dependencies.autoload_paths << autoload_once_path
        end

        it 'should not add path to ActiveSupport::Dependencies.autoload_paths' do
          expect {
            setup
          }.to_not change(ActiveSupport::Dependencies, :autoload_paths)
        end
      end

      context 'without autoload_path in ActiveSupport::Dependencies.autoload_paths' do
        it 'should add path to ActiveSupport::Dependencies.autoload_paths' do
          setup

          ActiveSupport::Dependencies.autoload_paths.should include(autoload_once_path)
        end
      end
    end

    context 'once_paths' do
      it 'should call once_paths' do
        # once in #all_paths and once when called directly
        autoload.should_receive(:once_paths).twice.and_return([])

        setup
      end

      context 'with autoload_path in ActiveSupport::Dependencies.autoload_once_paths' do
        before(:each) do
          ActiveSupport::Dependencies.autoload_once_paths << autoload_once_path
        end

        it 'should not add path to ActiveSupport::Dependencies.autoload_once_paths' do
          expect {
            setup
          }.to_not change(ActiveSupport::Dependencies, :autoload_once_paths)
        end
      end

      context 'without autoload_path in ActiveSupport::Dependencies.autoload_once_paths' do
        it 'should add path to ActiveSupport::Dependencies.autoload_once_paths' do
          setup

          ActiveSupport::Dependencies.autoload_once_paths.should include(autoload_once_path)
        end
      end
    end
  end
end