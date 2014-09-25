require 'metasploit/model/search/operation/integer'

# Search operation on an attribute that has a `Set<Integer>` for acceptable
# {Metasploit::Model::Search::Operation::Base values}.
class Metasploit::Model::Search::Operation::Set::Integer < Metasploit::Model::Search::Operation::Set
  include Metasploit::Model::Search::Operation::Integer::Value
end