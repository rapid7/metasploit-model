module Metasploit
  module Model
    module Search
      module Operator
        # Methods to lookup help text for an operator with a given `#name` registered to a given `#klass`.
        module Help
          # @note This uses I18n.translate along with {Metasploit::Model::Translation#search_i18n_scope},
          #   the value is not cached to support changing the I18n.locale and getting the correct help message for that
          #   locale.
          #
          # The help for this operator.
          #
          # @see https://github.com/rails/rails/blob/6c2810b8ed692004dca43e554982cdfdb8517b80/activemodel/lib/active_model/errors.rb#L408-L435
          def help
            defaults = []
            klass_i18n_scope = klass.i18n_scope

            klass.lookup_ancestors.each do |ancestor|
              # a specific operator for a given Class#ancestors member
              defaults << :"#{klass_i18n_scope}.ancestors.#{ancestor.model_name.i18n_key}.search.operator.names.#{name}.help"
            end

            operator_class = self.class
            operator_i18n_scope = operator_class.i18n_scope

            operator_class.lookup_ancestors.each do |ancestor|
              # a specific name for a given operator
              defaults << :"#{operator_i18n_scope}.search.operator.ancestors.#{ancestor.model_name.i18n_key}.names.#{name}.help"
              # a specific operator class
              defaults << :"#{operator_i18n_scope}.search.operator.ancestors.#{ancestor.model_name.i18n_key}.help"
            end

            # use first default as key because it is most specific default, that is closest to klass.
            key = defaults.shift
            options = {
                default: defaults,
                model: klass.model_name.human,
                name: name
            }

            ::I18n.translate(key, options)
          end
        end
      end
    end
  end
end