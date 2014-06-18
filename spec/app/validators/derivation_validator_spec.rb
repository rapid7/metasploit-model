require 'spec_helper'

describe DerivationValidator do
  subject(:derivation_validator) do
    described_class.new(
        :attributes => attributes
    )
  end

  let(:attribute) do
    :full_name
  end

  let(:attributes) do
    [
        attribute
    ]
  end

  context '#validate_each' do
    subject(:validate_each) do
      derivation_validator.validate_each(record, attribute, value)
    end

    let(:record) do
      record_class.new
    end

    let(:record_class) do
      # capture attribute name in local so it is accessible in Class block scope.
      attribute = self.attribute

      Class.new do
        include ActiveModel::Validations

        validates attribute,
                  :derivation => true
      end
    end

    let(:value) do
      nil
    end

    context 'without derived_<attribute>' do
      it 'should raise error' do
        expect {
          validate_each
        }.to raise_error(NoMethodError)
      end
    end

    context 'with derived_<attribute>' do
      let(:derived_value) do
        'derived_value'
      end

      before(:each) do
        # capture for record scope
        derived_value = self.derived_value

        record.define_singleton_method("derived_#{attribute}") do
          derived_value
        end
      end

      context 'with value matches derived_<attribute>' do
        let(:value) do
          derived_value
        end

        it 'should not record any errors' do
          validate_each

          record.errors.should be_empty
        end
      end

      context 'without value matches derived_<attribute>' do
        let(:value) do
          'non_derived_value'
        end

        it 'should record error on attribute' do
          validate_each

          record.errors[attribute].should include('must match its derivation')
        end
      end
    end
  end
end