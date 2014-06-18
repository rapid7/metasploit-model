require 'spec_helper'

describe Metasploit::Model::Search::Operator::Deprecated::App do
  subject(:operator) do
    described_class.new(
        :klass => klass
    )
  end

  let(:klass) do
    Class.new
  end

  it { should be_a Metasploit::Model::Search::Operator::Delegation }

  context 'CONSTANTS' do
    context 'STANCE_BY_APP' do
      subject(:stance_by_app) do
        described_class::STANCE_BY_APP
      end

      its(['client']) { should == 'passive' }
      its(['server']) { should == 'aggressive' }
    end
  end

  context '#operate_on' do
    subject(:operation) do
      operator.operate_on(formatted_value)
    end

    let(:stance_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :stance,
          :klass => klass,
          :type => :string
      )
    end

    before(:each) do
      operator.stub(:operator).with('stance').and_return(stance_operator)
    end

    context 'with client' do
      let(:formatted_value) do
        'client'
      end

      its('operator.name') { should == :stance }
      its(:value) { should == 'passive' }
    end

    context 'with server' do
      let(:formatted_value) do
        'server'
      end

      its('operator.name') { should == :stance }
      its(:value) { should == 'aggressive' }
    end
  end
end