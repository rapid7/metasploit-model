# Search operation with {Metasploit::Model::Search::Operation::Base#operator} with `#type` `:string`.
class Metasploit::Model::Search::Operation::String < Metasploit::Model::Search::Operation::Base
  include Metasploit::Model::Search::Operation::String::Value

  #
  # Validations
  #

  validates :value,
            :presence => true
end