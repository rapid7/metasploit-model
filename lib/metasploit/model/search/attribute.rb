module Metasploit
  module Model
    module Search
      # Registers attributes that can be searched.
      module Attribute
        extend ActiveSupport::Concern

        include Metasploit::Model::Search::With

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
          # @return (see Metasploit::Model::Search::With::ClassMethods#search_with)
          # @raise [Metasploit::Model::Invalid] unless attribute is present
          # @raise [Metasploit::Model::Invalid] unless :type is present
          def search_attribute(attribute, options={})
            search_with Metasploit::Model::Search::Operator::Attribute,
                        :attribute => attribute,
                        :type => options[:type]
          end
        end
      end
    end
  end
end