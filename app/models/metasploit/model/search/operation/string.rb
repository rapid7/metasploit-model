# Search operation with {Metasploit::Model::Search::Operation::Base#operator} with `#type` `:string`.
class Metasploit::Model::Search::Operation::String < Metasploit::Model::Search::Operation::Base
  #
  # Validations
  #

  validates :value,
            :presence => true

  #
  # Methods
  #

  # Sets {Metasploit::Model::Search::Operation::Base#value} by type casting to a String.
  #
  # @param formatted_value [#to_s]
  # @return [String]
  def value=(formatted_value)
    @value = formatted_value.to_s
  end
end