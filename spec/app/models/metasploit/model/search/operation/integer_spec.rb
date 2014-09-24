require 'spec_helper'

describe Metasploit::Model::Search::Operation::Integer do
  context 'validation' do
    it { should validate_numericality_of(:value).only_integer }
  end

  it_should_behave_like 'Metasploit::Model::Search::Operation::Value::Integer'
end