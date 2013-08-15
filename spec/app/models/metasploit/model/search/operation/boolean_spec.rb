require 'spec_helper'

describe Metasploit::Model::Search::Operation::Boolean do
  context 'CONSTANTS' do
    context 'FORMATTED_VALUE_TO_VALUE' do
      subject(:formatted_value_to_value) do
        described_class::FORMATTED_VALUE_TO_VALUE
      end

      its(['false']) { should be_false }
      its(['true']) { should be_true }
    end
  end

  context 'validations' do
    it { should ensure_inclusion_of(:value).in_array([false, true]) }
  end

  context '#value' do
    subject(:value) do
      operation.value
    end

    let(:operation) do
      described_class.new(:value => formatted_value)
    end

    context "with 'false'" do
      let(:formatted_value) do
        'false'
      end

      it { should be_false }
    end

    context "with 'true'" do
      let(:formatted_value) do
        'true'
      end

      it { should be_true }
    end

    context 'with other' do
      let(:formatted_value) do
        'unknown'
      end

      it 'should return value unparsed' do
        value.should == formatted_value
      end
    end
  end
end