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

  it { should be_a Metasploit::Model::Search::Operator::Union }

  context 'CONSTANTS' do
    subject(:association_names) do
      described_class::ASSOCIATION_NAMES
    end

    it { should include 'platforms' }
    it { should include 'targets' }
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end

  context '#children' do
    include_context 'Metasploit::Model::Search::Operator::Union#children'

    let(:formatted_value) do
      'platform_or_target'
    end

    let(:platform_class) do
      Class.new
    end

    let(:platform_name_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :name,
          :klass => platform_class,
          :type => :string
      )
    end

    let(:platforms_name_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :platforms,
          :attribute_operator => platform_name_operator,
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
      operator.stub(:operator).with('platforms.name').and_return(platforms_name_operator)
      operator.stub(:operator).with('targets.name').and_return(targets_name_operator)
    end

    context 'platforms.name' do
      subject(:operation) do
        child('platforms.name')
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