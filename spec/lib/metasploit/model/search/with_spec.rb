require 'spec_helper'

describe Metasploit::Model::Search::With do
  let(:base_class) do
    described_class = self.described_class

    Class.new do
      include described_class
    end
  end

  context 'search_with' do
    subject(:search_with_operator) do
      base_class.search_with operator_class, options
    end

    let(:options) do
      {
          a: 1,
          b: 2
      }
    end

    let(:operator) do
      double(
          'Operator',
          :name => 'op',
          :valid! => nil
      )
    end

    let(:operator_class) do
      double(
          'Operator Class',
          :new => operator
      )
    end

    it 'should pass given options to operator_class.new' do
      operator_class.should_receive(:new).with(
          hash_including(options)
      ).and_return(operator)

      search_with_operator
    end

    it 'should merge :klass into options passed to operator.new' do
      operator_class.should_receive(:new).with(
          hash_including(
              :klass => base_class
          )
      )

      search_with_operator
    end

    it 'should validate operator' do
      operator_class.stub(:new).and_return(operator)

      operator.should_receive(:valid!)

      search_with_operator
    end

    it 'should add operator to search_with_operator_by_name' do
      search_with_operator

      base_class.search_with_operator_by_name[operator.name].should == operator
    end
  end

  context 'search_with_operator_by_name' do
    subject(:search_with_operator_by_name) do
      base_class.search_with_operator_by_name
    end

    it 'should default to empty Hash' do
      search_with_operator_by_name.should == {}
    end
  end
end