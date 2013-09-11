require 'spec_helper'

describe Metasploit::Model::I18n do
  let(:base_module) do
    described_class = self.described_class

    Module.new do
      extend described_class

      def self.root
        Metasploit::Model.root.join('spec', 'dummy')
      end
    end
  end

  context '#i18n_load_directories' do
    subject(:i18n_load_directories) do
      base_module.i18n_load_directories
    end

    it 'should use #root to convert #relative_i18n_load_directories to absolute paths' do
      relative_i18n_load_directories = [
          'foo/bar'
      ]

      base_module.stub(relative_i18n_load_directories: relative_i18n_load_directories)

      i18n_load_directories.should == [Metasploit::Model.root.join('spec', 'dummy', 'foo', 'bar').to_path]
    end
  end

  context '#i18n_load_paths' do
    subject(:i18n_load_paths) do
      base_module.i18n_load_paths
    end

    it 'should be a flat Array' do
      nested_array = ['a', 'b']
      Dir.stub(:glob).and_return(nested_array)
      base_module.stub(i18n_load_directories: ['d1', 'd2'])

      expect(i18n_load_paths).to match_array(nested_array + nested_array)
    end

    it 'should look for yml files' do
      Dir.should_receive(:glob) do |glob|
        glob.should end_with('*.yml')
      end

      i18n_load_paths
    end
  end

  context '#relative_i18n_load_directories' do
    subject(:relative_i18n_load_directories) do
      base_module.relative_i18n_load_directories
    end

    it { should include('config/locales') }
  end

  context '#set_i18n_load_paths' do
    subject(:set_i18n_load_paths) do
      base_module.set_i18n_load_paths
    end

    let(:i18n_load_path) do
      Metasploit::Model.root.join('spec', 'dummy', 'config', 'locales', 'en.yml').to_path
    end

    let(:i18n_load_paths) do
      [
          i18n_load_path
      ]
    end

    before(:each) do
      @before_i18n_load_path = ::I18n.load_path

      base_module.stub(i18n_load_paths: i18n_load_paths)
    end

    after(:each) do
      ::I18n.load_path = @before_i18n_load_path
    end

    context 'with in I18n.load_path already' do
      before(:each) do
        ::I18n.load_path << i18n_load_path
      end

      it 'should not add path to I18n.load_path' do
        expect {
          set_i18n_load_paths
        }.to_not change(::I18n, :load_path)
      end
    end

    context 'without in I18n.load_path already' do
      it 'should add path to I18n.load_path' do
        set_i18n_load_paths

        ::I18n.load_path.should include(i18n_load_path)
      end
    end
  end
end