module Metasploit
  module Model
    # DSL to define associations and attributes that can be searched.  Making an association searchable, will expose
    # the attributes that association's class defined as searchable.
    module Search
      extend ActiveSupport::Concern

      include Metasploit::Model::Search::Association
      include Metasploit::Model::Search::Attribute
      include Metasploit::Model::Search::With

      # Allows operators registered with {Metasploit::Model::Search::Association::ClassMethods#search_association} and
      # {Metasploit::Model::Search::Attribute::ClassMethods#search_attribute} to be looked up by name.
      module ClassMethods
        # Collects all search attributes from search associations and all attributes from this class to show the valid
        # search operators to search.
        #
        # @return [Hash{Symbol => Metasploit::Model::Search::Operator}] Maps
        #   {Metasploit::Model::Search::Operator::Base#name} to {Metasploit::Model::Search::Operator::Base#name}.
        def search_operator_by_name
          unless instance_variable_defined? :@search_operator_by_name
            @search_operator_by_name = {}

            search_with_operator_by_name.each_value do |operator|
              @search_operator_by_name[operator.name] = operator
            end

            search_association_operators.each do |operator|
              @search_operator_by_name[operator.name] = operator
            end
          end

          @search_operator_by_name
        end
      end
    end
  end
end