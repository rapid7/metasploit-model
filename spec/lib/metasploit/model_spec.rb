require 'spec_helper'

describe Metasploit::Model do
  let(:root_pathname) do
    spec_lib_metasploit_pathname = Pathname.new(__FILE__).parent
    spec_lib_pathname = spec_lib_metasploit_pathname.parent
    spec_pathname = spec_lib_pathname.parent

    spec_pathname.parent
  end

  it 'should extend Metasploit::Model::Configured' do
    described_class.singleton_class.should include Metasploit::Model::Configured
  end

  context 'configuration' do
    subject(:configuration) do
      described_class.configuration
    end

    context 'autoload' do
      subject(:autoload) do
        configuration.autoload
      end

      context 'once_paths' do
        subject(:once_paths) do
          autoload.once_paths
        end

        it { should include root_pathname.join('lib').to_path }
      end

      context 'paths' do
        subject(:paths) do
          autoload.paths
        end

        it { should include root_pathname.join('app', 'models').to_path }
        it { should include root_pathname.join('app', 'validators').to_path }
      end
    end

    context 'i18n' do
      subject(:i18n) do
        configuration.i18n
      end

      context 'paths' do
        subject(:paths) do
          i18n.paths
        end

        it { should include root_pathname.join('config', 'locales', 'en.yml').to_path }
      end
    end
  end

  context 'root' do
    subject(:root) do
      described_class.root
    end

    it 'should be top-level directory of metasploit-model project' do
      root.should == root_pathname
    end
  end
end