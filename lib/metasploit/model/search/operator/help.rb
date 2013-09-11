module Metasploit
  module Model
    module Search
      module Operator
        # Methods to lookup help text for an operator with a given `#name` registered to a given `#klass`.
        module Help
          # @note This uses I18n.translate along with {Metasploit::Model::Search::Translation#search_i18n_scope},
          #   the value is not cached to support changing the I18n.locale and getting the correct help message for that
          #   locale.
          #
          # The help for this operator.
          def help
            ::I18n.translate(help_translation_key)
          end

          # The key passed to `I18n.translate` to generate {#help}.
          #
          # @return [String]
          def help_translation_key
            @help_translation_key ||= "#{klass.search_i18n_scope}.search_with.#{name}.help"
          end
        end
      end
    end
  end
end