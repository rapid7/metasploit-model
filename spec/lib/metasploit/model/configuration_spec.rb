require 'spec_helper'

describe Metasploit::Model::Configuration do
  include_context 'Metasploit::Model::Configuration'

  subject do
    configuration
  end

  it_should_behave_like 'Metasploit::Model::Configuration::Parent#child',
                        :autoload,
                        class: Metasploit::Model::Configuration::Autoload

  it_should_behave_like 'Metasploit::Model::Configuration::Parent#child',
                        :i18n,
                        class: Metasploit::Model::Configuration::I18n

  context '#root' do
    subject(:root) do
      configuration.root
    end

    let(:configuration) do
      described_class.new
    end

    context 'with setting first' do
      #
      # lets
      #

      let(:expected_root_pathname) do
        Metasploit::Model.root.join('spec', 'dummy')
      end

      #
      # Callbacks
      #

      before(:each) do
        configuration.root = expected_root
      end

      context 'with Pathname' do
        let(:expected_root) do
          expected_root_pathname
        end

        it { should be_a Pathname }

        it 'should return set Pathname' do
          root.should == expected_root
        end
      end

      context 'with String' do
        let(:expected_root) do
          expected_root_pathname.to_s
        end

        it { should be_a Pathname }

        it 'should return String as Pathname' do
          root.should == expected_root_pathname
        end
      end
    end

    context 'without setting first' do
      specify {
        expect {
          root
        }.to raise_error Metasploit::Model::Configuration::Error
      }
    end
  end

  context '#setup' do
    subject(:setup) do
      configuration.setup
    end

    before(:each) do
      @before_autoload_paths = ActiveSupport::Dependencies.autoload_paths.dup
      ActiveSupport::Dependencies.autoload_paths.clear

      @before_autoload_once_paths = ActiveSupport::Dependencies.autoload_once_paths.dup
      ActiveSupport::Dependencies.autoload_once_paths.clear

      @before_i18n_load_path = ::I18n.load_path
    end

    after(:each) do
      ActiveSupport::Dependencies.autoload_paths = @before_autoload_paths
      ActiveSupport::Dependencies.autoload_once_paths = @before_autoload_once_paths

      ::I18n.load_path = @before_i18n_load_path
    end

    it 'should setup autoload' do
      configuration.autoload.should_receive(:setup)

      setup
    end
  end
end