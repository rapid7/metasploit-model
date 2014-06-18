require 'spec_helper'

describe NilValidator do
  subject(:nil_validator) do
    described_class.new(
        :attributes => attributes
    )
  end

  let(:attribute) do
    :nil_thing
  end

  let(:attributes) do
    [
        attribute
    ]
  end

  context '#validate_each' do
    subject(:validate_each) do
      nil_validator.validate_each(record, attribute, value)
    end

    let(:record) do
      record_class.new
    end

    let(:record_class) do
      # capture attribute for Class.new scope
      attribute = self.attribute

      Class.new do
        include ActiveModel::Validations

        #
        # Validations
        #

        validates attribute,
                  :nil => true
      end
    end

    context 'with value' do
      let(:value) do
        ''
      end

      it 'should record error on attribute' do
        validate_each

        record.errors[attribute].should include('must be nil')
      end
    end

    context 'without value' do
      let(:value) do
        nil
      end

      it 'should not record any error' do
        validate_each

        record.errors.should be_empty
      end
    end
  end
end