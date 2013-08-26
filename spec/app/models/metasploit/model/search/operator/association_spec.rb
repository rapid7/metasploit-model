require 'spec_helper'

describe Metasploit::Model::Search::Operator::Association do
  it { should be_a Metasploit::Model::Search::Operator::Single }

  context 'validations' do
    it { should validate_presence_of(:association) }
    it { should validate_presence_of(:attribute_operator) }
  end

  context 'delegate :to  => attribute_operator' do
    let(:association) do
      FactoryGirl.generate :metasploit_model_search_operator_association_association
    end

    let(:association_operator) do
      described_class.new(
          :association => association,
          :attribute_operator => attribute_operator
      )
    end

    let(:attribute_operator) do
      double('Metasploit::Model::Search::Operator::Attribute')
    end

    context '#attribute' do
      subject(:attribute) do
        association_operator.attribute
      end

      it 'should delegate to #attribute_operator' do
        attribute_operator.should_receive(:attribute)

        attribute
      end
    end

    context '#help' do
      subject(:help) do
        association_operator.help
      end

      it 'should delegate to #attribute_operator' do
        attribute_operator.should_receive(:help)

        help
      end
    end

    context '#type' do
      subject(:type) do
        association_operator.type
      end

      it 'should delegate to #attribute_operator' do
        attribute_operator.should_receive(:type)

        type
      end
    end
  end

  context '#name' do
    subject(:name) do
      association_operator.name
    end

    let(:association) do
      FactoryGirl.generate :metasploit_model_search_operator_association_association
    end

    let(:association_operator) do
      described_class.new(
          :association => association,
          :attribute_operator => attribute_operator
      )
    end

    let(:attribute) do
      FactoryGirl.generate :metasploit_model_search_operator_attribute_attribute
    end

    let(:attribute_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => attribute
      )
    end

    it { should be_a Symbol }

    it 'should be <association>.<attribute>' do
      name.to_s.should == "#{association}.#{attribute}"
    end
  end
end