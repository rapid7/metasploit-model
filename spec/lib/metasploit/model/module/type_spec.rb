require 'spec_helper'

describe Metasploit::Model::Module::Type do
  context 'CONSTANTS' do
    context 'ALL' do
      subject(:all) do
        described_class::ALL
      end

      it 'should not include ANY' do
        all.should_not include(described_class::ANY)
      end

      it 'should include AUX' do
        all.should include(described_class::AUX)
      end

      it 'should include ENCODER' do
        all.should include(described_class::ENCODER)
      end

      it 'should include EXPLOIT' do
        all.should include(described_class::EXPLOIT)
      end

      it 'should include NOP' do
        all.should include(described_class::NOP)
      end

      it 'should include PAYLOAD' do
        all.should include(described_class::PAYLOAD)
      end

      it 'should include POST' do
        all.should include(described_class::POST)
      end
    end

    context 'ANY' do
      subject(:any) do
        described_class::ANY
      end

      it { should == '_any_' }
    end

    context 'AUX' do
      subject(:aux) do
        described_class::AUX
      end

      it { should == 'auxiliary' }
    end

    context 'ENCODER' do
      subject(:encoder) do
        described_class::ENCODER
      end

      it { should == 'encoder' }
    end

    context 'EXPLOIT' do
      subject(:exploit) do
        described_class::EXPLOIT
      end

      it { should == 'exploit' }
    end

    context 'NON_PAYLOAD' do
      subject(:non_payload) do
        described_class::NON_PAYLOAD
      end

      it 'should include AUX' do
        non_payload.should include(described_class::AUX)
      end

      it 'should include ENCODER' do
        non_payload.should include(described_class::ENCODER)
      end

      it 'should include EXPLOIT' do
        non_payload.should include(described_class::EXPLOIT)
      end

      it 'should include NOP' do
        non_payload.should include(described_class::NOP)
      end

      it 'should not include PAYLOAD' do
        non_payload.should_not include(described_class::PAYLOAD)
      end

      it 'should include POST' do
        non_payload.should include(described_class::POST)
      end
    end

    context 'NOP' do
      subject(:nop) do
        described_class::NOP
      end

      it { should == 'nop' }
    end

    context 'PAYLOAD' do
      subject(:payload) do
        described_class::PAYLOAD
      end

      it { should == 'payload' }
    end

    context 'POST' do
      subject(:post) do
        described_class::POST
      end

      it { should == 'post'}
    end
  end
end