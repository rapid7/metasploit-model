require 'spec_helper'

describe Metasploit::Model::Search::Operator::Deprecated::Platform do
  subject(:operator) do
    described_class.new(
        :klass => klass,
        :name => name
    )
  end

  let(:klass) do
    Class.new
  end

  let(:name) do
    ['os', 'platform'].sample
  end

  it { should be_a Metasploit::Model::Search::Operator::Group::Union }

  context 'CONSTANTS' do
    context 'FORMATTED_OPERATORS' do
      subject(:formatted_operators) do
        described_class::FORMATTED_OPERATORS
      end

      it { should include 'platforms.fully_qualified_name' }
      it { should include 'targets.name' }
    end
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end

  context '#children' do
    include_context 'Metasploit::Model::Search::Operator::Group::Union#children'

    let(:formatted_value) do
      'platform_or_target'
    end

    let(:platform_class) do
      Class.new
    end

    let(:platform_fully_qualified_name_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :fully_qualified_name,
          :klass => platform_class,
          :type => :string
      )
    end

    let(:platforms_fully_qualified_name_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :platforms,
          :klass => klass,
          :source_operator => platform_fully_qualified_name_operator
      )
    end

    let(:target_class) do
      Class.new
    end

    let(:target_name_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :name,
          :klass => target_class,
          :type => :string
      )
    end

    let(:targets_name_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :targets,
          :klass => klass,
          :source_operator => target_name_operator
      )
    end

    before(:each) do
      operator.stub(:operator).with(
          'platforms.fully_qualified_name'
      ).and_return(
          platforms_fully_qualified_name_operator
      )
      operator.stub(:operator).with('targets.name').and_return(targets_name_operator)
    end

    context 'platforms.fully_qualified_name' do
      subject(:operation) do
        child('platforms.fully_qualified_name')
      end

      context 'Metasploit::Model::Search::Operation::Association#source_operation' do
        subject(:source_operation) {
          operation.source_operation
        }

        it 'uses formatted value for value' do
          expect(source_operation.value).to eq(formatted_value)
        end
      end
    end

    context 'targets.name' do
      subject(:operation) do
        child('targets.name')
      end

      context 'Metasploit::Model::Search::Operation::Association#source_operation' do
        subject(:source_operation) {
          operation.source_operation
        }

        it 'uses formatted value for value' do
          expect(source_operation.value).to eq(formatted_value)
        end
      end
    end
  end
end