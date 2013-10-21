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

            search_association_set.each do |association|
              begin
                reflection = reflect_on_association(association)
              rescue NameError
                raise NameError,
                      "#{self} does not respond to reflect_on_association.  " \
                      "It can be added to ActiveModels by including Metasploit::Model::Association into the class."
              end

              unless reflection
                raise Metasploit::Model::Association::Error.new(:model => self, :name => association)
              end

              association_class = reflection.klass

              # don't use search_operator_by_name as association operators on operators won't work
              association_class.search_with_operator_by_name.each_value do |with_operator|
                # non-attribute operators on association are assumed not to work
                if with_operator.respond_to? :attribute
                  association_operator = Metasploit::Model::Search::Operator::Association.new(
                      :association => association,
                      :attribute_operator => with_operator,
                      :klass => self
                  )
                  @search_operator_by_name[association_operator.name] = association_operator
                end
              end
            end
          end

          @search_operator_by_name
        end
      end
    end
  end
end