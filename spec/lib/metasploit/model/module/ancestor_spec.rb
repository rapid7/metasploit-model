require 'spec_helper'

describe Metasploit::Model::Module::Ancestor do
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
    end

    context 'MODULE_TYPES' do
      subject(:module_types) do
        described_class::MODULE_TYPES
      end

      it { should include('auxiliary') }
      it { should include('encoder') }
      it { should include('exploit') }
      it { should include('nop') }
      it { should include('payload') }
      it { should include('post') }
    end
  end
end