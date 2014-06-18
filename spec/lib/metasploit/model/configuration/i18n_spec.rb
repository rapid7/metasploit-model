require 'spec_helper'

describe Metasploit::Model::Configuration::I18n do
  include_context 'Metasploit::Model::Configuration'

  let(:i18n) do
    described_class.new.tap { |i18n|
      i18n.configuration = configuration
    }
  end

  context '#directories' do
    subject(:directories) do
      i18n.directories
    end

    it 'should use configuration.root to convert #relative_directories to absolute paths' do
      relative_directories = [
          'foo/bar'
      ]

      i18n.stub(relative_directories: relative_directories)

      directories.should == [Metasploit::Model.root.join('spec', 'dummy', 'foo', 'bar').to_path]
    end
  end

  context '#paths' do
    subject(:paths) do
      i18n.paths
    end

    it 'should be a flat Array' do
      nested_array = ['a', 'b']
      Dir.stub(:glob).and_return(nested_array)
      i18n.stub(directories: ['d1', 'd2'])

      expect(paths).to match_array(nested_array + nested_array)
    end

    it 'should look for yml files' do
      Dir.should_receive(:glob) do |glob|
        glob.should end_with('*.yml')
      end

      paths
    end
  end

  context '#relative_directories' do
    subject(:relative_directories) do
      i18n.relative_directories
    end

    it { should include('config/locales') }
  end

  context '#setup' do
    subject(:setup) do
      i18n.setup
    end

    let(:path) do
      Metasploit::Model.root.join('spec', 'dummy', 'config', 'locales', 'en.yml').to_path
    end

    let(:paths) do
      [
          path
      ]
    end

    before(:each) do
      @before_i18n_load_path = ::I18n.load_path

      i18n.stub(paths: paths)
    end

    after(:each) do
      ::I18n.load_path = @before_i18n_load_path
    end

    context 'with in I18n.load_path already' do
      before(:each) do
        ::I18n.load_path << path
      end

      it 'should not add path to I18n.load_path' do
        expect {
          setup
        }.to_not change(::I18n, :load_path)
      end
    end

    context 'without in I18n.load_path already' do
      it 'should add path to I18n.load_path' do
        setup

        ::I18n.load_path.should include(path)
      end
    end
  end
end