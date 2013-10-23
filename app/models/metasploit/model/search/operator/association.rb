# A search operator declared with
# {Metasploit::Model::Search::Association::ClassMethods#search_association search_association}.
class Metasploit::Model::Search::Operator::Association < Metasploit::Model::Search::Operator::Single
  #
  # Attributes
  #

  # @!attribute [rw] association
  #   The association on which {Metasploit::Model::Search::Operator::Attribute#attribute} is declared searchable.
  #
  #   @return [Symbol] association on {Metasploit::Model::Search::Operator::Base#klass klass}.
  attr_accessor :association

  # @!attribute [rw] attribute_operator
  #   The {Metasploit::Model::Search::Operator::Attribute operator} as declared on the {#association} class.
  #
  #   @return [Metasploit::Model::Search::Operator::Attribute]
  attr_accessor :attribute_operator

  #
  # Validations
  #

  validates :association, :presence => true
  validates :attribute_operator, :presence => true

  #
  # Methods
  #

  delegate :attribute,
           :attribute_set,
           :help,
           :type,
           :to => :attribute_operator

  # The name of this operator.
  #
  # @return [String] <association>.<attribute>
  def name
    @name ||= "#{association}.#{attribute}".to_sym
  end
end