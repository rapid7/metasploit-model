require 'spec_helper'

describe Metasploit::Model::Search::Operation::Null, type: :model do
  context 'validation' do
    context 'operator' do
      context 'null' do
        let(:error) do
          I18n.translate(
              'metasploit.model.errors.models.metasploit/model/search/operation/null.attributes.operator.type',
              type: Metasploit::Model::Search::Operator::Null
          )
        end

        let(:errors) do
          operation.errors[:operator]
        end

        let(:klass) do
          Class.new
        end

        let(:operation) do
          described_class.new(
              :operator => operator
          )
        end

        let(:operator) do
          operator_class.new(
              :klass => klass
          )
        end

        before(:each) do
          operation.valid?
        end

        context 'with Metasploit::Model::Search::Operator::Null' do
          let(:operator_class) do
            Metasploit::Model::Search::Operator::Null
          end

          it 'should not record error' do
            errors.should_not include(error)
          end
        end

        context 'without Metasploit::Model::Search::Operator::Null' do
          let(:operator_class) do
            Metasploit::Model::Search::Operator::Base
          end

          it 'should record error' do
            errors.should include(error)
          end

          it 'should have no other errors, so that it would be valid without this type check on operator' do
            operation.errors.size.should == 1
          end
        end
      end
    end
  end
end