require 'spec_helper'

describe Metasploit::Model::Search::Operator::Group::Base, type: :model do
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

    #
    # lets
    #

    let(:children) do
      [
          invalid_child,
          valid_child
      ]
    end

    let(:valid_child) do
      double('Valid Child', valid?: true)
    end

    let(:invalid_child) do
      double('Invalid Child', valid?: false)
    end

    #
    # Callbacks
    #

    before(:each) do
      operator.stub(:children => children)
    end

    it { should be_a Metasploit::Model::Search::Operation::Group::Base }

    context 'children' do
      subject(:operation_children) do
        operation.children
      end

      it 'rejected invalid children' do
        expect(operation_children).not_to include(invalid_child)
      end

      it 'includes valid children' do
        expect(operation_children).to include(valid_child)
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