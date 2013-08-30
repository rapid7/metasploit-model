require 'spec_helper'

describe Metasploit::Model::Search::Operator::Union do
  subject(:operator) do
    described_class.new
  end

  let(:formatted_value) do
    'formatted_value'
  end

  context '#children' do
    subject(:children) do
      operator.children(formatted_value)
    end

    it 'should be abstract' do
      expect {
        children
      }.to raise_error(NotImplementedError)
    end
  end

  context '#operate_on' do
    subject(:operation) do
      operator.operate_on(formatted_value)
    end

    let(:children) do
      [
          double('Child')
      ]
    end

    before(:each) do
      operator.stub(:children => children)
    end

    it { should be_a Metasploit::Model::Search::Operation::Union }

    context 'children' do
      subject(:operation_children) do
        operation.children
      end

      it 'should be #children' do
        operation_children.should == children
      end
    end

    context 'operator' do
      subject(:operation_operator) do
        operation.operator
      end

      it 'should be the operator itself' do
        operation_operator.should == operator
      end
    end

    context 'value' do
      subject(:value) do
        operation.value
      end

      it 'should be formatted value' do
        value.should == formatted_value
      end
    end
  end
end