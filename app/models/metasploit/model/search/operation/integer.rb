require 'metasploit/model/search/operation'

# Search operation with {Metasploit::Model::Search::Operation::Base#operator} with `#type` `:integer`.  Validates that
# value is an integer.
class Metasploit::Model::Search::Operation::Integer < Metasploit::Model::Search::Operation::Base
  require 'metasploit/model/search/operation/integer/value'

  include Metasploit::Model::Search::Operation::Integer::Value

  #
  # Validations
  #

  validates :value,
            :numericality => {
                :only_integer => true
            }
end