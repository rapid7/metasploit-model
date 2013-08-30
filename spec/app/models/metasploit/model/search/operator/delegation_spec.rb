require 'spec_helper'

describe Metasploit::Model::Search::Operator::Delegation do
  subject(:operator) do
    described_class.new(
        :klass => klass
    )
  end

  let(:klass) do
    Class.new
  end

  it { should be_a Metasploit::Model::Search::Operator::Base }
  it { should be_a Metasploit::Model::Search::Operator::Help }

  context 'operator_name' do
    subject(:operator_name) do
      subclass.operator_name
    end

    let(:subclass) do
      Class.new(described_class)
    end

    context 'with namespace' do
      let(:base_name) do
        'Demodulized'
      end

      before(:each) do
        stub_const("Namespace::#{base_name}", subclass)
      end

      it 'should remove namespace' do
        operator_name.should == base_name.downcase.to_sym
      end
    end

    context 'with Camelized' do
      before(:each) do
        stub_const("CamelCase", subclass)
      end

      it 'should convert name to underscore' do
        operator_name.should == :camel_case
      end
    end
  end

  context '#operator' do
    subject(:named_operator) do
      operator.send(:operator, formatted_operator)
    end

    let(:formatted_operator) do
      double('Formatted Operator', :to_sym => :formatted_operator)
    end

    let(:search_operator) do
      double('Search Operator')
    end

    let(:search_operator_by_name) do
      {
          formatted_operator.to_sym => search_operator
      }
    end

    before(:each) do
      klass.stub(:search_operator_by_name => search_operator_by_name)
    end

    it 'should convert formatted_operator to Symbol' do
      formatted_operator.should_receive(:to_sym)

      named_operator
    end

    it 'should look up operator name in search_operator_by_name of #klass' do
      named_operator.should == search_operator
    end

    context 'with name not in klass.search_operator_by_name' do
      let(:search_operator_by_name) do
        {}
      end

      it 'should raise ArgumentError' do
        expect {
          named_operator
        }.to raise_error(ArgumentError, "No operator with name #{formatted_operator.to_sym.inspect} on #{klass}")
      end
    end
  end

  context '#name' do
    subject(:name) do
      operator.name
    end

    it 'should delegate to operator_name' do
      operator_name = double('Operator Name')
      operator.class.stub(:operator_name => operator_name)

      name.should == operator_name
    end
  end
end