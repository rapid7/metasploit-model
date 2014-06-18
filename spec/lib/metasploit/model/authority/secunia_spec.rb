require 'spec_helper'

describe Metasploit::Model::Authority::Secunia do
  context 'designation_url' do
    subject(:designation_url) do
      described_class.designation_url(designation)
    end

    let(:designation) do
      FactoryGirl.generate :metasploit_model_reference_secunia_designation
    end

    it 'should be under advisories directory' do
      designation_url.should == "https://secunia.com/advisories/#{designation}/"
    end
  end
end