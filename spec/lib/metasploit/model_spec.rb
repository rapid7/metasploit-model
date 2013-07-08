require 'spec_helper'

describe Metasploit::Model do
  let(:root_pathname) do
    spec_lib_metasploit_pathname = Pathname.new(__FILE__).parent
    spec_lib_pathname = spec_lib_metasploit_pathname.parent
    spec_pathname = spec_lib_pathname.parent

    spec_pathname.parent
  end

  it { should respond_to :autoload_validators }
  it { should respond_to :validators_pathname }

  context 'app_pathname' do
    subject(:app_pathname) do
      described_class.app_pathname
    end

    it 'should join app to root' do
      root = mock('root Pathname')

      root.should_receive(:join).with('app')
      described_class.should_receive(:root).and_return(root)

      app_pathname
    end

    it 'should be app' do
      app_pathname.should == root_pathname.join('app')
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