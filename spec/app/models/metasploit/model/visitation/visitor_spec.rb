require 'spec_helper'

describe Metasploit::Model::Visitation::Visitor do
  context 'validations' do
    it { should validate_presence_of :block }
    it { should validate_presence_of :module_name }
    it { should validate_presence_of :parent }
  end

  context '#initialize' do
    subject(:instance) do
      described_class.new(
          :module_name => module_name,
          :parent => parent,
          &block
      )
    end

    let(:block) do
      lambda { |node|
        node
      }
    end

    let(:module_name) do
      'Visited::Node'
    end

    let(:parent) do
      Class.new
    end

    it 'should set #block from &block' do
      instance.block.should == block
    end

    it 'should set #module_name from :module_name' do
      instance.module_name.should == module_name
    end

    it 'should set #parent from :parent' do
      instance.parent.should == parent
    end
  end
end