require 'spec_helper'

describe Metasploit::Model::Search::Operation::Integer do
  context 'validation' do
    it { should validate_numericality_of(:value).only_integer }
  end

  context '#value' do
    subject(:value) do
      operation.value
    end

    let(:operation) do
      described_class.new(:value => formatted_value)
    end

    context 'with Integer' do
      let(:formatted_value) do
        1
      end

      it 'should pass through Integer' do
        value.should == formatted_value
      end
    end

    context 'with Integer#to_s' do
      let(:formatted_value) do
        integer.to_s
      end

      let(:integer) do
        1
      end

      it 'should convert String to Integer' do
        value.should == integer
      end
    end

    context 'with mix text and numerals' do
      let(:formatted_value) do
        "#{integer}mix"
      end

      let(:integer) do
        123
      end

      it 'should not extract the number' do
        value.should_not == integer
      end

      it 'should pass through the full value' do
        value.should == formatted_value
      end
    end

    context 'with Float' do
      let(:formatted_value) do
        0.1
      end

      it 'should not truncate Float to Integer' do
        value.should_not == formatted_value.to_i
      end

      it 'should pass through Float' do
        value.should == formatted_value
      end
    end
  end
end