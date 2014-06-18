require 'spec_helper'

describe Metasploit::Model::Authority::Zdi do
  context 'designation_url' do
    subject(:designation_url) do
      described_class.designation_url(designation)
    end

    let(:designation) do
      FactoryGirl.generate :metasploit_model_reference_zdi_designation
    end

    it 'should be under advisories directory' do
      expect(designation_url).to match_regex(/advisories\/.*#{designation}/)
    end

    it "should prefix designation with 'ZDI'" do
      expect(designation_url).to match_regex(/ZDI-#{designation}/)
    end
  end
end