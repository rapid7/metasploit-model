module Metasploit
  module Model
    module Search
      # Generalizes operators from attributes to anything directly registered as an operator on a class.
      module With
        extend ActiveSupport::Concern

        # Defines `search_with` DSL, which is a lower-level way than search_attribute to add operators.  `search_with`
        # allows instance of arbitrary operator_classes to be registered in {#search_with_operator_by_name}.
        module ClassMethods
          # Declares that this class should be search with an instance of the given `operator_class`.
          #
          # @param operator_class [Class<Metasploit::Model::Search::Operator::Base>] a class to initialize.
          # @param options [Hash] Options passed to `operator_class.new` along with `{:klass => self}`, so that the
          #   `operator_class` instance knows it was registered as search this class.
          # @return [Metasploit::Model::Search::Operator::Base]
          # @raise (see Metasploit::Model::Base#invalid!)
          def search_with(operator_class, options={})
            merged_operations = options.merge(
                :klass => self
            )
            operator = operator_class.new(merged_operations)
            operator.valid!

            search_with_operator_by_name[operator.name] = operator
          end

          # Operators registered with {#search_with}.
          #
          # @return [Hash{Symbol => Metasploit::Model::Search::Operator::Base}] Maps
          #   {Metasploit::Model::Search::Operator::Base#name} keys to {Metasploit::Model::Search::Operator::Base#name}
          #   values.
          def search_with_operator_by_name
            @search_with_operator_by_name ||= {}
          end
        end
      end
    end
  end
end