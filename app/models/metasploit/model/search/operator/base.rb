# @abstract Declare search operators using {Metasploit::Model::Search::ClassMethods#search_attribute} and include
#   operators from associations with {Metasploit::Model::Search::ClassMethods#search_association}.
#
# A search operator.
class Metasploit::Model::Search::Operator::Base < Metasploit::Model::Base
  include ActiveModel::Validations

  #
  # Attributes
  #

  # @!attribute [rw] klass
  #   The class on which this operator is usable.
  #
  #   @return [Class]
  attr_accessor :klass

  #
  # Validations
  #

  validates :klass, :presence => true

  #
  # Methods
  #

  # Creates an {Metasploit::Model::Search::Operation::Base operation} of the correct type for this operator's {#type}.
  #
  # @param formatted_value [String] the unparsed value passed to this operator in {Metasploit::Model::Search::Query
  #   a formatted search query}.
  def operate_on(formatted_value)
    operation_class.new(
        :value => formatted_value,
        :operator => self
    )
  end

  # @abstract subclass and derive operator name from attributes of subclass.
  #
  # Name of this operator.
  #
  # @return [String]
  # @raise [NotImplementedError]
  def name
    raise NotImplementedError
  end

  # @abstract subclass and derive operator type.
  #
  # Type of the attribute.
  #
  # @return [Symbol]
  # @raise [NotImplementedError]
  def type
    raise NotImplementedError
  end

  protected

  # The {#type}-specific {Metasploit::Model::Search::Operation::Base} subclass.
  #
  # @return [Class<Metasploit::Model::Search::Operation::Base>]
  def operation_class
    @operation_class ||= "Metasploit::Model::Search::Operation::#{type.to_s.camelize}".constantize
  end
end