require 'spec_helper'

describe Metasploit::Model::Search::Operator::Attribute do
  it { should be_a Metasploit::Model::Search::Operator::Help }
  it { should be_a Metasploit::Model::Search::Operator::Single }

  context 'CONSTANTS' do
    context 'TYPES' do
      subject(:types) do
        described_class::TYPES
      end

      it { should include(:boolean) }
      it { should include(:date) }
      it { should include(:integer) }
      it { should include(:string) }
    end
  end

  context 'validations' do
    it { should validate_presence_of(:attribute) }
    it { should ensure_inclusion_of(:type).in_array(described_class::TYPES) }
  end

  context '#name' do
    subject(:name) do
      attribute_operator.name
    end

    let(:attribute) do
      FactoryGirl.generate :metasploit_model_search_operator_attribute_attribute
    end

    let(:attribute_operator) do
      described_class.new(
          :attribute => attribute
      )
    end

    it 'should be #attribute' do
      name.should == attribute
    end
  end
end