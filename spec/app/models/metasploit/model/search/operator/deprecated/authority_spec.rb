require 'spec_helper'

describe Metasploit::Model::Search::Operator::Deprecated::Authority do
  subject(:operator) do
    described_class.new(
        :abbreviation => abbreviation,
        :klass => klass
    )
  end

  let(:abbreviation) do
    FactoryGirl.generate :metasploit_model_authority_abbreviation
  end

  let(:klass) do
    Class.new
  end

  let(:search_i18n_scope) do
    'search.i18n.scope'
  end

  before(:each) do
    klass.stub(:search_i18n_scope => search_i18n_scope)
  end

  it { should be_a Metasploit::Model::Search::Operator::Delegation }

  context 'validations' do
    it { should validate_presence_of :abbreviation }
  end

  context '#name' do
    subject(:name) do
      operator.name
    end

    it 'should be #abbreviation' do
      name.should == abbreviation
    end
  end

  context '#help' do
    subject(:help) do
      operator.help
    end

    it 'should pass #abbreviation to translate' do
      I18n.should_receive(:translate).with(
          operator.help_translation_key,
          hash_including(
              :abbreviation => abbreviation
          )
      )

      help
    end
  end

  context '#help_translation_key' do
    subject(:help_translation_key) do
      operator.help_translation_key
    end

    it 'should always use authority as its name' do
      help_translation_key.should end_with('search_with.authority.help')
    end
  end

  context '#operate_on' do
    subject(:operations) do
      operator.operate_on(formatted_value)
    end

    def operation_named(formatted_operator)
      operations.find { |operation|
        operation.operator.name == formatted_operator.to_sym
      }
    end

    let(:abbreviation_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :abbreviation,
          :klass => authority_class,
          :type => :string
      )
    end

    let(:authority_class) do
      Class.new
    end

    let(:authorities_abbreviation_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :authorities,
          :attribute_operator => abbreviation_operator,
          :klass => klass
      )
    end

    let(:designation_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :designation,
          :klass => reference_class,
          :type => :string
      )
    end

    let(:formatted_value) do
      FactoryGirl.generate :metasploit_model_reference_designation
    end

    let(:reference_class) do
      Class.new
    end

    let(:references_designation_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :references,
          :attribute_operator => designation_operator,
          :klass => klass
      )
    end

    before(:each) do
      operator.stub(:operator).with('authorities.abbreviation').and_return(authorities_abbreviation_operator)
      operator.stub(:operator).with('references.designation').and_return(references_designation_operator)
    end

    context 'authorities.abbreviation' do
      subject(:operation) do
        operation_named('authorities.abbreviation')
      end

      it 'should use #abbrevation for value' do
        operation.value.should == abbreviation
      end
    end

    context 'references.designation' do
      subject(:operation) do
        operation_named('references.designation')
      end

      it 'should use formatted value for value' do
        operation.value.should == formatted_value
      end
    end
  end
end