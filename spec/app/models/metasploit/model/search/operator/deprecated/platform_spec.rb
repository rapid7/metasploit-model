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
          :attribute_operator => platform_fully_qualified_name_operator,
          :klass => klass
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
          :attribute_operator => target_name_operator,
          :klass => klass
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

      it 'should use formatted value for value' do
        operation.value.should == formatted_value
      end
    end

    context 'targets.name' do
      subject(:operation) do
        child('targets.name')
      end

      it 'should use formatted value for value' do
        operation.value.should == formatted_value
      end
    end
  end
end