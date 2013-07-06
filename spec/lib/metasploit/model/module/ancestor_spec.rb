require 'spec_helper'

describe Metasploit::Model::Module::Ancestor do
  context 'CONSTANTS' do
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