require 'spec_helper'

describe Metasploit::Model::Reference do
  it_should_behave_like 'Metasploit::Model::Reference' do
    subject(:reference) do
      FactoryGirl.build(reference_factory)
    end

    def attribute_type(attribute)
      type_by_attribute = {
          :designation => :string,
          :url => :text
      }

      type = type_by_attribute.fetch(attribute)

      type
    end

    def authority_with_abbreviation(abbreviation)
      Dummy::Authority.with_abbreviation(abbreviation)
    end

    let(:authority_factory) do
      :dummy_authority
    end

    let(:base_class) do
      Dummy::Reference
    end

    let(:reference_factory) do
      :dummy_reference
    end
  end

  context 'factories' do
    context 'dummy_reference' do
      subject(:dummy_reference) do
        FactoryGirl.build(:dummy_reference)
      end

      it { should be_valid }

      its(:authority) { should_not be_nil }
      its(:designation) { should_not be_nil }
      its(:url) { should_not be_nil }
    end

    context 'obsolete_dummy_reference' do
      subject(:obsolete_dummy_reference) do
        FactoryGirl.build(:obsolete_dummy_reference)
      end

      it { should be_valid }

      its(:authority) { should_not be_nil }
      its(:designation) { should_not be_nil }
      its(:url) { should be_nil }
    end

    context 'url_dummy_reference' do
      subject(:url_dummy_reference) do
        FactoryGirl.build(:url_dummy_reference)
      end

      it { should be_valid }

      its(:authority) { should be_nil }
      its(:designation) { should be_nil }
      its(:url) { should_not be_nil }
    end
  end
end