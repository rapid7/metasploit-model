require 'spec_helper'

describe Metasploit::Model::Authority::Cwe do
  context 'designation_url' do
    subject(:designation_url) do
      described_class.designation_url(designation)
    end

    let(:designation) do
      FactoryGirl.generate :metasploit_model_reference_cwe_designation
    end

    it 'should be under cwe subdomain and definitions directory' do
      designation_url.should == "https://cwe.mitre.org/data/definitions/#{designation}.html"
    end
  end
end