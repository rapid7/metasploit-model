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
          :klass => klass,
          :source_operator => abbreviation_operator
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
          :klass => klass,
          :source_operator => designation_operator
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

      context 'Metasploit::Model::Search::Operation::Association#source_operation' do
        subject(:source_operation) {
          operation.source_operation
        }

        it 'uses #abbreviation for value' do
          expect(source_operation.value).to eq(abbreviation)
        end
      end
    end

    context 'references.designation' do
      subject(:operation) do
        operation_named('references.designation')
      end

      context 'Metasploit::Model::Search::Operation::Association#source_operation' do
        subject(:source_operation) {
          operation.source_operation
        }

        it 'uses formatted value for value' do
          expect(source_operation.value).to eq(formatted_value)
        end
      end
    end
  end
end