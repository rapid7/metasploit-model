module Metasploit
  module Model
    module Search
      # Registers attributes that can be searched.
      module Attribute
        extend ActiveSupport::Concern

        # Adds {#search_attribute} DSL to make {Metasploit::Model::Search::Operator::Attribute attribute search
        # operators}.
        module ClassMethods
          # Registers attribute for search.  Help for the operator supports i18n.
          #
          # @example defining help
          #    # lib/metasploit/model/module/instance.rb
          #    module Metasploit::Model::Module::Instance
          #      include Metasploit::Model::Search
          #
          #      included do
          #        search_attribute :description, :type => :string
          #      end
          #    end
          #
          #    # config/locales/en.yml
          #    en:
          #      metasploit:
          #        model:
          #          module:
          #            instance:
          #              search_attribute:
          #                description:
          #                  help: "A long, paragraph description of what the module does."
          #
          # @param attribute [#to_sym] name of attribute to search.
          # @param options [Hash{Symbol => String}]
          # @option options [Symbol] :type The type of the attribute.  Used to determine how to parse the search values
          #   and which modifiers are supported.
          # @return [void]
          # @raise [Metasploit::Model::Invalid] unless attribute is present
          # @raise [Metasploit::Model::Invalid] unless :type is present
          def search_attribute(attribute, options={})
            operator = Metasploit::Model::Search::Operator::Attribute.new(
                :attribute => attribute,
                :klass => self,
                :type => options[:type]
            )
            operator.valid!

            search_operator_by_attribute[operator.attribute] = operator
          end

          # Set of all attributes that are searchable.
          #
          # @example Adding attribute to search
          #   search_attribute :name, :help => 'The name of the object.'
          #
          # @return [Hash{Symbol => Metasploit::Model::Search::Operator::Attribute}] Maps
          #   {Metasploit::Model::Search::Operator::Attribute#attribute} to its
          #   {Metasploit::Model::Search::Operator::Attribute}.
          def search_operator_by_attribute
            @search_operator_by_attribute ||= {}
          end
        end
      end
    end
  end
end