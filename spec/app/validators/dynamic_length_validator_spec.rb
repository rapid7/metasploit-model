require 'spec_helper'

describe DynamicLengthValidator do
    subject(:dynamic_length_validator) do
    described_class.new(
        :attributes => attributes
    )
  end

  let(:attribute) do
    :things
  end

  let(:attributes) do
    [
        attribute
    ]
  end

  context '#validate_each' do
    subject(:validate_each) do
      dynamic_length_validator.validate_each(record, attribute, value)
    end

    let(:record) do
      record_class.new
    end

    let(:record_class) do
      # capture attribute name in local so it is accessible in Class block scope.
      attribute = self.attribute
      dynamic_length_validation_options = self.dynamic_length_validation_options

      Class.new do
        include ActiveModel::Validations

        validates attribute,
                  dynamic_length:  true

        define_method(:dynamic_length_validation_options) do |attribute|
          dynamic_length_validation_options
        end
      end
    end

    let(:value) do
      [1] * value_length
    end

    let(:value_length) do
      0
    end

    context 'record.dynamic_length_validation_options' do
      context 'with {}' do
        let(:dynamic_length_validation_options) do
          {}
        end

        it 'should not add any errors to record' do
          validate_each

          record.errors.should be_empty
        end
      end

      context 'with :is' do
        let(:dynamic_length_validation_options) do
          {
              is: is
          }
        end

        let(:is) do
          0
        end

        context 'with same length as :is' do
          let(:value_length) do
            is
          end

          it 'should not add error on record' do
            validate_each

            record.errors.should be_empty
          end
        end

        context 'without same length as :is' do
          let(:value_length) do
            is + 1
          end

          it 'should record :wrong_length error on attribute' do
            record.errors.should_receive(:add).with(
                attribute,
                :wrong_length,
                hash_including(
                    count: is
                )
            )

            validate_each
          end

          context 'with :wrong_length' do
            let(:dynamic_length_validation_options) do
              super().merge(
                  wrong_length: wrong_length
              )
            end

            let(:wrong_length) do
              'Wrong length message'
            end

            it 'should pass :wrong_length value as :message' do
              record.errors.should_receive(:add).with(
                  attribute,
                  :wrong_length,
                  hash_including(
                      message: wrong_length,
                      count: is
                  )
              )

              validate_each
            end
          end
        end
      end

      context 'with :maximum' do
        let(:dynamic_length_validation_options) do
          {
              maximum: maximum
          }
        end

        let(:maximum) do
          1
        end

        context 'with less than :maximum' do
          let(:value_length) do
            maximum - 1
          end

          it 'should not add error on record' do
            validate_each

            record.errors.should be_empty
          end
        end

        context 'with same as :maximum' do
          let(:value_length) do
            maximum
          end

          it 'should not add error on record' do
            validate_each

            record.errors.should be_empty
          end
        end

        context 'with greater than :maximum' do
          let(:value_length) do
            maximum + 1
          end

          it 'should record :too_long error on attribute' do
            record.errors.should_receive(:add).with(
                attribute,
                :too_long,
                hash_including(
                    count: maximum
                )
            )

            validate_each
          end

          context 'with :too_long' do
            let(:dynamic_length_validation_options) do
              super().merge(
                  too_long: too_long
              )
            end

            let(:too_long) do
              'Too long message'
            end

            it 'should pass :too_long value as :message' do
              record.errors.should_receive(:add).with(
                  attribute,
                  :too_long,
                  hash_including(
                      message: too_long,
                      count: maximum
                  )
              )

              validate_each
            end
          end
        end
      end

      context 'with :minimum' do
        let(:dynamic_length_validation_options) do
          {
              minimum: minimum
          }
        end

        let(:minimum) do
          1
        end

        context 'with less than :minimum' do
          let(:value_length) do
            minimum - 1
          end

          it 'should record :too_short error on attribute' do
            record.errors.should_receive(:add).with(
                attribute,
                :too_short,
                hash_including(
                    count: minimum
                )
            )

            validate_each
          end

          context 'with :too_short' do
            let(:dynamic_length_validation_options) do
              super().merge(
                  too_short: too_short
              )
            end

            let(:too_short) do
              'Too short message'
            end

            it 'should pass :too_short value as :message' do
              record.errors.should_receive(:add).with(
                  attribute,
                  :too_short,
                  hash_including(
                      message: too_short,
                      count: minimum
                  )
              )

              validate_each
            end
          end
        end

        context 'with same as :minimum' do
          let(:value_length) do
            minimum
          end

          it 'should not add error on record' do
            validate_each

            record.errors.should be_empty
          end
        end

        context 'with greater than :minimum' do
          let(:value_length) do
            minimum + 1
          end

          it 'should not add error on record' do
            validate_each

            record.errors.should be_empty
          end
        end
      end
    end
  end
end