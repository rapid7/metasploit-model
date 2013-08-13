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

  # @abstract subclass and derive operator name from attributes of subclass.
  #
  # Name of this operator.
  #
  # @return [String]
  # @raise [NotImplementedError]
  def name
    raise NotImplementedError
  end
end