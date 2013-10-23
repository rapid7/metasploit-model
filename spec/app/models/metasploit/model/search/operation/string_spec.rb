require 'spec_helper'

describe Metasploit::Model::Search::Operation::String do
  context 'validation' do
    it { should validate_presence_of(:value) }
  end

  it_should_behave_like 'Metasploit::Model::Search::Operation::String::Value'
end