require 'spec_helper'

describe Metasploit::Model::Autoload do
  let(:base_module) do
    described_class = self.described_class

    Module.new do
      extend described_class

      def self.root
        Metasploit::Model.root.join('spec', 'dummy')
      end
    end
  end

  context 'all_autoload_paths' do
    subject(:all_autoload_paths) do
      base_module.all_autoload_paths
    end

    it 'should include autoload_once_paths' do
      all_autoload_paths.to_set.should be_superset(base_module.autoload_once_paths.to_set)
    end

    it 'should include autoload_paths' do
      all_autoload_paths.to_set.should be_superset(base_module.autoload_paths.to_set)
    end
  end

  context 'autoload_once_paths' do
    subject(:autoload_once_paths) do
      base_module.autoload_once_paths
    end

    it 'should call relative_autoload_once_paths' do
      base_module.should_receive(:relative_autoload_once_paths).and_return([])

      autoload_once_paths
    end

    it 'should have absolute paths' do
      autoload_once_paths.each do |autoload_once_path|
        autoload_once_path.should == File.absolute_path(autoload_once_path)
      end
    end
  end

  context 'autoload_paths' do
    subject(:autoload_paths) do
      base_module.autoload_paths
    end

    it 'should call relative_autoload_paths' do
      base_module.should_receive(:relative_autoload_paths).and_return([])

      autoload_paths
    end

    it 'should have absolute paths' do
      autoload_paths.each do |autoload_path|
        autoload_path.should == File.absolute_path(autoload_path)
      end
    end
  end

  context 'relative_autoload_once_paths' do
    subject(:relative_autoload_once_paths) do
      base_module.relative_autoload_once_paths
    end

    it { should include('lib') }
  end

  context 'relative_autoload_paths' do
    subject(:relative_autoload_paths) do
      base_module.relative_autoload_paths
    end

    it { should include('app/models') }
    it { should include('app/validators') }
  end

  context 'set_autoload_paths' do
    subject(:set_autoload_paths) do
      base_module.set_autoload_paths
    end

    let(:autoload_once_path) do
      Metasploit::Model.root.join('spec', 'dummy', 'lib').to_path
    end

    before(:each) do
      @before_autoload_paths = ActiveSupport::Dependencies.autoload_paths.dup
      ActiveSupport::Dependencies.autoload_paths.clear

      @before_autoload_once_paths = ActiveSupport::Dependencies.autoload_once_paths.dup
      ActiveSupport::Dependencies.autoload_once_paths.clear

      base_module.stub(:autoload_once_paths).and_return([autoload_once_path])
      base_module.stub(:autoload_paths).and_return([])
    end

    after(:each) do
      ActiveSupport::Dependencies.autoload_paths = @before_autoload_paths
      ActiveSupport::Dependencies.autoload_once_paths = @before_autoload_once_paths
    end

    context 'autoload_paths' do
      it 'should call all_autoload_paths' do
        base_module.should_receive(:all_autoload_paths).and_return([])

        set_autoload_paths
      end

      context 'with autoload_path in ActiveSupport::Dependencies.autoload_paths' do
        before(:each) do
          ActiveSupport::Dependencies.autoload_paths << autoload_once_path
        end

        it 'should not add path to ActiveSupport::Dependencies.autoload_paths' do
          expect {
            set_autoload_paths
          }.to_not change(ActiveSupport::Dependencies, :autoload_paths)
        end
      end

      context 'without autoload_path in ActiveSupport::Dependencies.autoload_paths' do
        it 'should add path to ActiveSupport::Dependencies.autoload_paths' do
          set_autoload_paths

          ActiveSupport::Dependencies.autoload_paths.should include(autoload_once_path)
        end
      end
    end

    context 'autoload_once_paths' do
      it 'should call autoload_once_paths' do
        base_module.should_receive(:autoload_once_paths).and_return([])

        set_autoload_paths
      end

      context 'with autoload_path in ActiveSupport::Dependencies.autoload_once_paths' do
        before(:each) do
          ActiveSupport::Dependencies.autoload_once_paths << autoload_once_path
        end

        it 'should not add path to ActiveSupport::Dependencies.autoload_once_paths' do
          expect {
            set_autoload_paths
          }.to_not change(ActiveSupport::Dependencies, :autoload_once_paths)
        end
      end

      context 'without autoload_path in ActiveSupport::Dependencies.autoload_once_paths' do
        it 'should add path to ActiveSupport::Dependencies.autoload_once_paths' do
          set_autoload_paths

          ActiveSupport::Dependencies.autoload_once_paths.should include(autoload_once_path)
        end
      end
    end
  end
end