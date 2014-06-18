require 'spec_helper'

describe Metasploit::Model::Search::Operation::String::Value do
  it_should_behave_like 'Metasploit::Model::Search::Operation::String::Value' do
    let(:operation_class) do
      described_class = self.described_class

      Class.new(Metasploit::Model::Base) do
        include described_class

        #
        # Attributes
        #

        # @!attribute [rw] value
        attr_reader :value
      end
    end
  end
end