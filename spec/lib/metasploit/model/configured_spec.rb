require 'spec_helper'

describe Metasploit::Model::Configured do
  subject(:configured) do
    Module.new.tap { |m|
      m.extend described_class
    }
  end

  context 'configuration' do
    subject(:configuration) do
      configured.configuration
    end

    it { should be_a Metasploit::Model::Configuration }
  end

  context 'root' do
    subject(:root) do
      configured.root
    end

    it 'should delegate to configuration' do
      configured.configuration.should_receive(:root)

      root
    end
  end

  context 'setup' do
    subject(:setup) do
      configured.setup
    end

    it 'should delegate to configuration' do
      configured.configuration.should_receive(:setup)

      setup
    end
  end
end