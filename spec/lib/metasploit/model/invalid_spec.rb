require 'spec_helper'

describe Metasploit::Model::Invalid do
  subject(:invalid) do
    described_class.new(model)
  end

  let(:model) do
    model_class.new
  end

  let(:model_class) do
    Class.new do
      include ActiveModel::Validations
    end
  end

  it { should be_a Metasploit::Model::Error }

  it 'should use ActiveModel::Errors#full_messages' do
    model.errors.should_receive(:full_messages).and_call_original

    described_class.new(model)
  end

  it 'should translate errors using metasploit.model.invalid' do
    I18n.should_receive(:translate).with(
        'metasploit.model.errors.messages.model_invalid',
        hash_including(
            :errors => anything
        )
    ).and_call_original

    described_class.new(model)
  end

  it 'should set translated errors as message' do
    message = "translated message"
    I18n.stub(:translate).with('metasploit.model.errors.messages.model_invalid', anything).and_return(message)
    instance = described_class.new(model)

    instance.message.should == message
  end

  context '#model' do
    subject(:error_model) do
      invalid.model
    end

    it 'should be the passed in model' do
      error_model.should == model
    end
  end
end