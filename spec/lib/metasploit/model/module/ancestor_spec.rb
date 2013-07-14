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

      it 'should have same module types as Metasploit::Model::Module::Type::ALL' do
        directory_by_module_type.keys.should =~ Metasploit::Model::Module::Type::ALL
      end
    end
  end
end