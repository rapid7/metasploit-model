# Validates that `value` of `attribute` on `record` is meets the
# `record.dynamic_length_validation_options(attribute)`.
#
# Works similar to `LengthValidator`, but the minimum and maximum lengths are controlled dynamically by the `record` to
# allow the validation to vary based on some other attribute in the record.
class DynamicLengthValidator < ActiveModel::EachValidator
  # Validates that value's `#length` meets the minimum and maximum options in
  # `record.dynamic_length_validation_options(attribute)`.
  #
  # @param record [Object, #dynamic_length_validation_options] record that supports dynmaic length options on
  #   `attribute`.
  # @param attribute [Symbol] name of an attribute on `record` with the given `value`.
  # @param value [Object, #length] value of `attribute`.
  # @return [void]
  def validate_each(record, attribute, value)
    # dynamic_options are not checked for validity the way options would be for LengthValidator because
    # dynamic_length_validation_options can be {} in some cases.
    dynamic_options = record.dynamic_length_validation_options(attribute)
    value_length = value.length

    ActiveModel::Validations::LengthValidator::CHECKS.each do |key, validity_check|
      check_value = dynamic_options[key]

      if check_value
        unless value_length.send(validity_check, check_value)
          errors_options = dynamic_options.except(*ActiveModel::Validations::LengthValidator::RESERVED_OPTIONS)
          errors_options[:count] = check_value

          message = errors_options[:message]
          message_key = ActiveModel::Validations::LengthValidator::MESSAGES[key]

          unless message
            default_message = dynamic_options[message_key]

            if default_message
              errors_options[:message] = default_message
            end
          end

          record.errors.add(attribute, message_key, errors_options)
        end
      end
    end
  end
end