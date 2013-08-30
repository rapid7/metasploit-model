require 'spec_helper'

describe Metasploit::Model::Search::Operator::Help do
  subject(:operator) do
    operator_class.new
  end

  let(:operator_class) do
    described_class = self.described_class

    Class.new do
      include described_class
    end
  end

  context '#help' do
    subject(:help) do
      operator.help
    end

    let(:help_translation_key) do
      :help
    end

    before(:each) do
      operator.stub(:help_translation_key => help_translation_key)
    end

    it 'should translate #help_translation_key' do
      I18n.should_receive(:translate).with(help_translation_key)

      help
    end
  end

  context '#help_translation_key' do
    subject(:help_translation_key) do
      operator.help_translation_key
    end

    let(:klass) do
      Class.new
    end

    let(:name) do
      FactoryGirl.generate :metasploit_model_search_operator_base_name
    end

    before(:each) do
      stub_const('Metasploit::Model::Search::Operator::Help::Class', klass)

      klass.class_eval do
        extend Metasploit::Model::Search::Translation
      end

      operator.stub(
          :klass => klass,
          :name => name
      )
    end

    it "should start with #klass's #search_translation_key_prefix" do
      help_translation_key.should start_with(klass.search_i18n_scope)
    end

    it 'should include #name' do
      help_translation_key.should include(name.to_s)
    end
  end
end