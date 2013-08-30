# Operator that {#operate_on produces} {Metasploit::Model::Search::Operation::Union union operations}.
class Metasploit::Model::Search::Operator::Union < Metasploit::Model::Search::Operator::Delegation
  #
  # Methods
  #

  # {Metasploit::Model::Search::Operation::Union#children}.
  #
  # @param formatted_value [String] value parsed from formatted operation
  # @return [Array<Metasploit::Model::Search::Operation::Base>]
  def children(formatted_value)
    raise NotImplementedError
  end

  # Unions children operating on `formatted_value`.
  #
  # @param formatted_value [String] value parsed from formatted operation.
  # @return [Metasploit::Model::Search::Operation::Union]
  def operate_on(formatted_value)
    children = self.children(formatted_value)

    Metasploit::Model::Search::Operation::Union.new(
        :children => children,
        :operator => self,
        :value => formatted_value
    )
  end
end