# Search operation on an attribute that has a `Set<String>` for acceptable
# {Metasploit::Model::Search::Operation::Base values}.
class Metasploit::Model::Search::Operation::Set::String < Metasploit::Model::Search::Operation::Set
  begin
    include Metasploit::Model::Search::Operation::Value::String
  rescue LoadError => error
    warn "$LOAD_PATH =\n#{$LOAD_PATH.map{ |p| "  #{p}"}.join("\n")}"
    raise error
  end
end