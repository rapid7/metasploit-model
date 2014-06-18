require 'spec_helper'

describe Metasploit::Model::Configuration::Child do
  subject(:child) do
    described_class.new
  end

  context '#configuration' do
    subject(:configuration) do
      child.configuration
    end

    context 'default' do
      it { should be_nil }
    end

    it 'should be settable' do
      expected_configuration = double('Configuration')
      child.configuration = expected_configuration

      expect(child.configuration).to eq expected_configuration
    end
  end
end