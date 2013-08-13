require 'spec_helper'

describe Metasploit::Model::Search::Operator::Attribute do
  context 'CONSTANTS' do
    context 'TYPES' do
      subject(:types) do
        described_class::TYPES
      end

      it { should include(:boolean) }
      it { should include(:date) }
      it { should include(:integer) }
      it { should include(:string) }
    end
  end

  context 'validations' do
    it { should validate_presence_of(:attribute) }
    it { should ensure_inclusion_of(:type).in_array(described_class::TYPES) }
  end

  context '#help' do
    subject(:help) do
      attribute_operator.help
    end

    let(:attribute_operator) do
      described_class.new
    end

    let(:help_translation_key) do
      :help
    end

    before(:each) do
      attribute_operator.stub(:help_translation_key => help_translation_key)
    end

    it 'should translate #help_translation_key' do
      I18n.should_receive(:translate).with(help_translation_key)

      help
    end
  end

  context '#help_translation_key' do
    subject(:help_translation_key) do
      attribute_operator.help_translation_key
    end

    let(:attribute) do
      FactoryGirl.generate :metasploit_model_search_operator_attribute_attribute
    end

    let(:attribute_operator) do
      described_class.new(
        :attribute => attribute,
        :klass => klass
      )
    end

    let(:klass) do
      Class.new
    end

    before(:each) do
      stub_const('Metasploit::Model::Search::Operator::Attribute::Class', klass)

      klass.class_eval do
        extend Metasploit::Model::Search::Translation
      end
    end

    it "should start with #klass's #search_translation_key_prefix" do
      help_translation_key.should start_with(klass.search_i18n_scope)
    end

    it 'should include #attribute' do
      help_translation_key.should include(attribute.to_s)
    end
  end

  context '#name' do
    subject(:name) do
      attribute_operator.name
    end

    let(:attribute) do
      FactoryGirl.generate :metasploit_model_search_operator_attribute_attribute
    end

    let(:attribute_operator) do
      described_class.new(
          :attribute => attribute
      )
    end

    it 'should be #attribute' do
      name.should == attribute
    end
  end
end