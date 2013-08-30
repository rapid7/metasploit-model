module Metasploit
  module Model
    module Search
      # Registers associations that can be searched.
      module Association
        extend ActiveSupport::Concern

        # Adds {#search_association} DSL to make {Metasploit::Model::Search::Operator::Association association search
        # operators}.
        module ClassMethods
          # Registers association for search.
          #
          # @param association [#to_sym] name of association to search.
          # @return [void]
          def search_association(association)
            search_association_set.add(association.to_sym)
          end

          # Set of all associations that are searchable.
          #
          # @example Adding association to search
          #   search_association :things
          #
          # @return [Set<Symbol>]
          def search_association_set
            @search_association_set ||= Set.new
          end
        end
      end
    end
  end
end