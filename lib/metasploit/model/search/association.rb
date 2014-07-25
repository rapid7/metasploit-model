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
            search_association_tree[association.to_sym] ||= nil
          end

          # Registers association for search.
          #
          # @param associations [Array<Array, Hash, Symbol>, Hash, Symbol]
          # @return [void]
          def search_associations(*associations)
            expanded_associations = Metasploit::Model::Association::Tree.expand(associations)

            @search_association_tree = Metasploit::Model::Association::Tree.merge(
                search_association_tree,
                expanded_associations
            )
          end

          def search_association_operators
            @search_association_operators ||= Metasploit::Model::Association::Tree.operators(
                search_association_tree,
                class: self
            )
          end

          # Tree of associations that are searchable.
          #
          # @return [Hash{Symbol => Hash,nil}]
          def search_association_tree
            @search_association_tree ||= {}
          end
        end
      end
    end
  end
end