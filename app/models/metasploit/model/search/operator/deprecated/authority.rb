# Operator for the direct, single authority reference search.  Translates `<abbreviation>:<designation>` to
# `authorities.abbreviation:<abbreviation> references.designation:<designation>`.
class Metasploit::Model::Search::Operator::Deprecated::Authority < Metasploit::Model::Search::Operator::Delegation
  #
  # Attributes
  #

  # @!attribute [rw] abbreviation
  #   Value passed to `authorities.abbreviation` operator
  #
  #   @return [String]
  attr_accessor :abbreviation

  #
  # Validations
  #

  validates :abbreviation,
            :presence => true

  #
  # Methods
  #

  # Help for this operator.
  #
  # @return [String] translation of {#help_translation_key} with {#abbreviation} substituted in.
  def help
    I18n.translate(help_translation_key, :abbreviation => abbreviation)
  end

  # `I18n.translate` key for all authority operators for {Metasploit::Model::Search::Operator::Base#klass}.  The
  # translation should support substution of `%{abbreviation}` for individual instances of this class.
  #
  # @return [String]
  def help_translation_key
    @help_translation_key ||= "#{klass.search_i18n_scope}.search_with.authority.help"
  end

  alias_method :name, :abbreviation

  # Returns list of operations that search for the authority with {#abbreviation} and `formatted_value` for reference
  # designation.
  #
  # @return [Array<Metasploit::Model::Search::Operation::Base>] authorities.abbreviation:<abbreviation>
  #   references.designation:<formatted_value>
  def operate_on(formatted_value)
    operations = []

    authorities_abbreviation_operator = operator('authorities.abbreviation')
    operations << authorities_abbreviation_operator.operate_on(abbreviation)

    references_designation_operator = operator('references.designation')
    operations << references_designation_operator.operate_on(formatted_value)

    operations
  end
end