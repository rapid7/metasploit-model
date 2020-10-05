RSpec.describe AddressFormatValidator do
  subject(:address_format_validator) do
    described_class.new(
        :attributes => attributes
    )
  end

  let(:attribute) do
    :address
  end

  let(:attributes) do
    [
        attribute
    ]
  end

  context '#validate_each' do
    subject(:validate_each) do
      address_format_validator.validate_each(record, attribute, value)
    end

    let(:error) do
      'must be a valid (IP or hostname) address'
    end

    let(:record) do
      record_class.new
    end

    let(:record_class) do
      # capture for Class.new scope
      attribute = self.attribute

      Class.new do
        include ActiveModel::Validations

        #
        # Validations
        #

        validates attribute,
                  :address_format => true
      end
    end

    context 'address' do
      context 'in IPv4 format' do
        let(:value) do
          '192.168.0.1'
        end

        it 'should not record any errors' do
          validate_each

          expect(record.errors).to be_empty
        end
      end

      context 'in IPv6 format' do
        let(:value) do
          '::1'
        end

        it 'should not record any errors' do
          validate_each

          expect(record.errors).to be_empty
        end
      end

      context 'with a valid hostname' do
        let(:value) do
          'testvalue.test.com'
        end

        it 'should not record any errors' do
          validate_each

          expect(record.errors).to be_empty
        end
      end

      context 'with localhost' do
        let(:value) do
          'localhost'
        end

        it 'should not record any errors' do
          validate_each

          expect(record.errors).to be_empty
        end
      end

      context 'with blank address' do
        let(:value) do
          ''
        end

        it 'should record error' do
          validate_each

          expect(record.errors[attribute]).to include(error)
        end
      end

      context 'with nil value' do
        let(:value) do
          nil
        end

        it 'should record error on attribute' do
          validate_each

          expect(record.errors[attribute]).to include(error)
        end
      end

      context 'with a malformed hostname should record an error' do
        invalid_hostnames = ['testvalue.test.com:', 'testvalue-.test.com', '[testvalue.test.com]']
        invalid_hostnames.each do | entry |
          let(:value) do
            entry
          end

          it 'should record an error on attribute' do
            validate_each
            expect(record.errors[attribute]).to include(error)
          end
        end

      end
    end
  end
end
