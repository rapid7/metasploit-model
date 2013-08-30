# @abstract Operator that only returns a single operation from {#operate_on}.
class Metasploit::Model::Search::Operator::Single < Metasploit::Model::Search::Operator::Base
  #
  # Methods
  #

  # Creates an {Metasploit::Model::Search::Operation::Base operation} of the correct type for this operator's {#type}.
  #
  # @param formatted_value [String] the unparsed value passed to this operator in {Metasploit::Model::Search::Query
  #   a formatted search query}.
  # @return [Metasploit::Model::Search::Operation::Base] instance of {#operation_class}.
  def operate_on(formatted_value)
    operation_class.new(
        :value => formatted_value,
        :operator => self
    )
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
    unless instance_variable_defined? :@operation_class
      unless type
        raise ArgumentError, "operation_class cannot be derived for #{name} operator because its type is nil"
      end

      @operation_class = "Metasploit::Model::Search::Operation::#{type.to_s.camelize}".constantize
    end

    @operation_class
  end
end