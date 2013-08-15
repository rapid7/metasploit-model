require 'spec_helper'

describe Metasploit::Model::Search::Operator::Base do
  subject(:operator) do
    described_class.new
  end

  context 'validations' do
    it { should validate_presence_of(:klass) }
  end

  context '#name' do
    subject(:name) do
      operator.name
    end

    it 'should not be implemented' do
      expect {
        name
      }.to raise_error(NotImplementedError)
    end
  end

  context '#operate_on' do
    subject(:operate_on) do
      operator.operate_on(formatted_value)
    end

    let(:formatted_value) do
      'value'
    end

    let(:operation_class) do
      double('Operation Class')
    end

    before(:each) do
      operator.stub(:operation_class => operation_class)
    end

    it 'should call new on #operation_class' do
      operation_class.should_receive(:new).with(:value => formatted_value, :operator => operator)

      operate_on
    end

    it 'should return instance of #operation_class' do
      operation = double('Operation')
      operation_class.stub(:new => operation)

      operate_on.should == operation
    end
  end

  context "#operation_class" do
    subject(:operation_class) do
      operator.send(:operation_class)
    end

    before(:each) do
      operator.stub(:type => type)
    end

    context 'type' do
      context 'with :boolean' do
        let(:type) do
          :boolean
        end

        it { should == Metasploit::Model::Search::Operation::Boolean }
      end

      context 'with :date' do
        let(:type) do
          :date
        end

        it { should == Metasploit::Model::Search::Operation::Date }
      end

      context 'with :integer' do
        let(:type) do
          :integer
        end

        it { should == Metasploit::Model::Search::Operation::Integer }
      end

      context 'with :string' do
        let(:type) do
          :string
        end

        it { should == Metasploit::Model::Search::Operation::String }
      end
    end

  end

  context '#type' do
    subject(:type) do
      operator.type
    end

    it 'should not be implemented' do
      expect {
        type
      }.to raise_error(NotImplementedError)
    end
  end
end