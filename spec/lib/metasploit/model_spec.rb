require 'spec_helper'

describe Metasploit::Model do
  let(:root_pathname) do
    spec_lib_metasploit_pathname = Pathname.new(__FILE__).parent
    spec_lib_pathname = spec_lib_metasploit_pathname.parent
    spec_pathname = spec_lib_pathname.parent

    spec_pathname.parent
  end

  it { should respond_to :set_autoload_paths }

  context 'root' do
    subject(:root) do
      described_class.root
    end

    it 'should be top-level directory of metasploit-model project' do
      root.should == root_pathname
    end
  end
end