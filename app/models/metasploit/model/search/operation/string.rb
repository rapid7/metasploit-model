require 'metasploit/model/search/operation'

# Search operation with {Metasploit::Model::Search::Operation::Base#operator} with `#type` `:string`.
class Metasploit::Model::Search::Operation::String < Metasploit::Model::Search::Operation::Base
  require 'metasploit/model/search/operation/string/value'

  include Metasploit::Model::Search::Operation::String::Value

  #
  # Validations
  #

  validates :value,
            :presence => true
end