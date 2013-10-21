require 'spec_helper'

describe Metasploit::Model::Base do
  subject(:base_class) do
    Class.new(described_class)
  end

  it_should_behave_like 'Metasploit::Model::Translation',
                        metasploit_model_ancestor: Metasploit::Model::Base

  context '#initialize' do
    it 'should use public_send to set attributes' do
      attribute = :attribute
      value = double('Value')
      base_class.any_instance.should_receive(:public_send).with("#{attribute}=", value)

      base_class.new(attribute => value)
    end
  end

  context '#valid!' do
    subject(:valid!) do
      base_instance.valid!
    end

    let(:base_instance) do
      base_class.new
    end

    before(:each) do
      base_instance.stub(:valid? => valid)
    end

    context 'with valid' do
      let(:valid) do
        true
      end

      it 'should not raise error' do
        expect {
          valid!
        }.to_not raise_error
      end
    end

    context 'without valid' do
      let(:valid) do
        false
      end

      it 'should raise Metasploit::Model::Invalid' do
        expect {
          valid!
        }.to raise_error(Metasploit::Model::Invalid)
      end
    end
  end
end