require 'spec_helper'

describe Metasploit::Model::Search::Operation::Date do
  context 'validation' do
    context 'value' do
      before(:each) do
        operation.valid?
      end

      let(:error) do
        I18n.translate('activemodel.errors.models.metasploit/model/search/operation/date.attributes.value.unparseable_date')
      end

      let(:errors) do
        operation.errors[:value]
      end

      let(:operation) do
        described_class.new(:value => value)
      end

      context 'with Date' do
        let(:value) do
          Date.today
        end

        it 'should not record error' do
          errors.should_not include(error)
        end
      end

      context 'without Date' do
        let(:value) do
          'not a date'
        end

        it 'should record error' do
          errors.should include(error)
        end
      end
    end
  end

  context '#value' do
    subject(:value) do
      operation.value
    end

    let(:operation) do
      described_class.new(:value => formatted_value)
    end

    context 'with Date' do
      let(:formatted_value) do
        Date.today
      end

      it 'should be passed in Date' do
        value.should == formatted_value
      end
    end

    context 'without Date' do
      context 'with parseable' do
        let(:date) do
          Date.today
        end

        let(:formatted_value) do
          date.to_s
        end

        it 'should be parsed Date' do
          value.should == date
        end
      end

      context 'without parseable' do
        let(:formatted_value) do
          'not a date'
        end

        it 'should pass through value' do
          value.should be formatted_value
        end
      end
    end
  end
end