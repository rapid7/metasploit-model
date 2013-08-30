require 'spec_helper'

describe Metasploit::Model::Search::Operation::Union do
  it { should be_a Metasploit::Model::Search::Operation::Base }

  context 'validations' do
    it { should ensure_length_of(:children).is_at_least(1).with_short_message('is too short (minimum is 1 child)') }
  end
end