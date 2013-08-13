require 'spec_helper'

describe Metasploit::Model::Architecture do
  it_should_behave_like 'Metasploit::Model::Architecture' do
    subject(:architecture) do
      architecture_class.new
    end

    let(:architecture_class) do
      Dummy::Architecture
    end
  end
end