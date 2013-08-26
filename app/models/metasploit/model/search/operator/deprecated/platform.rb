# Translates `<name>:<value>` to the union of `platforms.name:<value>` and `targets.name:<value>` in order to support
# the `os` and `platform` operators.
class Metasploit::Model::Search::Operator::Deprecated::Platform < Metasploit::Model::Search::Operator::Union
  #
  # CONSTANTS
  #

  # Names of associations with a name attribute operator that should be part of {#children} for this union.
  ASSOCIATION_NAMES = [
      'platforms',
      'targets'
  ]

  #
  # Attributes
  #

  # @!attribute [rw] name
  #   Name of this operator
  #
  #   @return [Symbol]
  attr_accessor :name

  #
  # Validations
  #

  validates :name,
            :presence => true

  #
  # Methods
  #

  # Array of `platforms.name:<formatted_value>` and `targets.name:<formatted_value>` operations.
  #
  # @param formatted_value [String] value parsed from formatted operation.
  # @return [Array<Metasploit::Model::Search::Operation::Base>]
  def children(formatted_value)
    ASSOCIATION_NAMES.collect { |association_name|
      formatted_operator = "#{association_name}.name"
      association_operator = operator(formatted_operator)
      association_operator.operate_on(formatted_value)
    }
  end
end