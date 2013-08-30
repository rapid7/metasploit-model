module Metasploit
  module Model
    module Search
      # Namespace for search operations.  {parse} acts as a factory to parse a `String` and return a type-specific
      # operation.
      module Operation
        # @param options [Hash{Symbol => Object}]
        # @option options [Metasploit::Module::Search::Query] :query The query that the parsed operation is a part.
        # @option options [String] :formatted_operation A '<operator>:<value>' string.
        # @return [Metasploit::Model::Search::Operation::Base, Array<Metasploit::Model::Search::Operation::Base>]
        #   operation(s) parsed from the formatted operation.
        # @raise [KeyError] unless :formatted_operation is given.
        # @raise [KeyError] unless :query is given.
        def self.parse(options={})
          formatted_operation = options.fetch(:formatted_operation)
          query = options.fetch(:query)

          formatted_operator, formatted_value = formatted_operation.split(':', 2)
          operator = query.parse_operator(formatted_operator)
          operation_or_operations = operator.operate_on(formatted_value)

          operation_or_operations
        end
      end
    end
  end
end