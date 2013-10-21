# Uses #supports?(attribute) on record to decide whether to validate that the attribute is too long (when support is
# false) or too short (when support is true).
class SupportValidator < ActiveModel::EachValidator
  #
  # CONSTANTS
  #

  # The minimum length of `value` when `record` supports `attribute`
  MINIMUM_LENGTH = 1

  #
  # Methods
  #

  def validate_each(record, attribute, value)
    if record.supports?(attribute)
      if value.length < MINIMUM_LENGTH
        # pass count that triggers pluralization localization in translation, not the current count.
        record.errors.add(attribute, :supported)
      end
    else
      if value.length > 0
        # pass count that triggers pluralization localization in translation, not the current count.
        record.errors.add(attribute, :unsupported)
      end
    end
  end
end