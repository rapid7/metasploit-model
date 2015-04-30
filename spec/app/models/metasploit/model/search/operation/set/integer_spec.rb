require 'spec_helper'

describe Metasploit::Model::Search::Operation::Set::Integer, type: :model do
  it { should be_a Metasploit::Model::Search::Operation::Set }

  it_should_behave_like 'Metasploit::Model::Search::Operation::Value::Integer'
end