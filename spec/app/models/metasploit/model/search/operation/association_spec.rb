require 'spec_helper'

describe Metasploit::Model::Search::Operation::Association do
  subject(:operation) {
    described_class.new(
        source_operation: source_operation
    )
  }

  let(:source_operation) {
    nil
  }

  context 'validation' do
    before(:each) do
      operation.valid?
    end

    context 'errors on #source_operation' do
      subject(:source_operation_errors) {
        operation.errors[:source_operation]
      }

      let(:invalid_error) {
        I18n.translate!('errors.messages.invalid')
      }

      context 'with #source_operation' do
        let(:source_operation) {
          double('#source_operation', valid?: valid)
        }

        context 'with valid' do
          let(:valid) {
            true
          }

          it { should_not include(invalid_error) }
        end

        context 'without valid' do
          let(:valid) {
            false
          }

          it { should include(invalid_error) }
        end
      end

      context 'without #source_operation' do
        let(:blank_error) {
          I18n.translate!('errors.messages.blank')
        }

        let(:source_operation) {
          nil
        }

        it { should include(blank_error) }
        it { should_not include(invalid_error) }
      end
    end
  end

  it { should_not respond_to :value }
  it { should_not respond_to :value= }
end