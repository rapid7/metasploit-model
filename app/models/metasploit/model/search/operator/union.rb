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
  # @return [Metasploit::Model::Search::Operation::Union] Union will not contain {#children} that are invalid.
  def operate_on(formatted_value)
    children = self.children(formatted_value)

    # filter children for validity as valid values for one child won't necessarily be valid values for another child.
    # this is specifically a problem with Metasploit::Model::Search::Operation::Set as no partial matching is allowed,
    # but can also be a problem with string vs integer operations.
    valid_children = children.select(&:valid?)

    Metasploit::Model::Search::Operation::Union.new(
        :children => valid_children,
        :operator => self,
        :value => formatted_value
    )
  end
end