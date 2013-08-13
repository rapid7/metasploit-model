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
end