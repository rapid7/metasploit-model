# A search operator declared with
# {Metasploit::Model::Search::Attribute::ClassMethods#search_attribute search_attribute}.
class Metasploit::Model::Search::Operator::Attribute < Metasploit::Model::Search::Operator::Base
  #
  # CONSTANTS
  #

  # The valid {#type types}.
  TYPES = [
      :boolean,
      :date,
      :integer,
      :string
  ]

  #
  # Attributes
  #

  # @!attribute [r] attribute
  #   The attribute on {Metasploit::Model::Search::Operator::Base#klass klass} that is searchable.
  #
  #   @return [Symbol] the attribute name
  attr_accessor :attribute

  # @!attribute [r] type
  #   The type of {#attribute}.
  #
  #   @return [Symbol] Value from {TYPES}.
  attr_accessor :type

  #
  # Validations
  #

  validates :attribute, :presence => true
  validates :type,
            :inclusion => {
                :in => TYPES
            }

  #
  # Methods
  #

  # @note This uses I18n.translate along with {Metasploit::Model::Search::Operator::Base#search_i18n_scope},
  #   the value is not cached to support changing the I18n.locale and getting the correct help message for that locale.
  #
  # The help for this operator.
  def help
    I18n.translate(help_translation_key)
  end

  # The key passed to `I18n.translate` to generate {#help}.
  #
  # @return [String]
  def help_translation_key
    @help_translation_key ||= "#{klass.search_i18n_scope}.search_attribute.#{attribute}.help"
  end

  # The name of this operator.
  #
  # @return [String] <attribute>
  def name
    @name ||= attribute
  end
end
