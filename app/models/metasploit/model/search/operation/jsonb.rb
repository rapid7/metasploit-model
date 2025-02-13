# Search operation with {Metasploit::Model::Search::Operation::Base#operator} with `#type` ':jsonb'.
class Metasploit::Model::Search::Operation::Jsonb < Metasploit::Model::Search::Operation::Base
  #
  # Validations
  #

  validates :value,
            :presence => true

  #
  # Methods
  #

  # Sets {Metasploit::Model::Search::Operation::Base#value} by parsing the `formatted_value`
  # String and attempting to generate a valid JSON if it contains a colon.
  # Otherwise, it keeps the same value as a String.
  #
  # @param formatted_value [#to_s]
  # @return [String] representing a JSON if `formatted_value` contains a colon.
  #   Otherwise it is a the same as `formatted_value`
  def value=(formatted_value)
    @value = transform_value(formatted_value.to_s)
  end


  private

  # Transform an input String to a JSON if it contains a colon. It returns the String if not.
  # Also, the first colon is used as a delimiter between the key and the value.
  # Any subsequent colon will be part of the value.
  # Finally, it handles double/single quotes to escape any colon that are not
  # suppose to be a delimiter between the key and the value.
  #
  # @param input [#to_s]
  # @return [String] representing a JSON if `input` contains a colon. Otherwise it is a the same as `input`
  def transform_value(input)
    # Regex to find the first colon that is NOT inside quotes
    match = input.match(/((?:[^'":]++|"(?:\\.|[^"])*"|'(?:\\.|[^'])*')*?):(.*)/)

    # If no valid colon is found, return the original string
    return input unless match

    key = match[1].strip  # Extract key (before first valid colon)
    value = match[2].strip # Extract value (after first valid colon)

    # Remove starting and ending quotes and ensure they are valid JSON strings
    key = key.gsub(/^["'](.*)["']$/, '\1').to_json
    value = value.gsub(/^["'](.*)["']$/, '\1').to_json
    "{#{key}: #{value}}"
  end

end
