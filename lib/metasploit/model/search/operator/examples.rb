module Metasploit
  module Model
    module Search
      module Operator
        module Examples

          # @note This uses I18n.translate along with {Metasploit::Model::Translation#search_i18n_scope},
          #   the value is not cached to support changing the I18n.locale and getting the correct help message for that
          #   locale.
          #
          # An array of example usage of this particular operator
          #
          # @return [Array<String>] a list of example uses of this operator
          def examples
            defaults = []
            klass_i18n_scope = klass.i18n_scope

            klass.lookup_ancestors.each do |ancestor|
              # a specific operator for a given Class#ancestors member
              defaults << :"#{klass_i18n_scope}.ancestors.#{ancestor.model_name.i18n_key}.search.operator.names.#{name}.examples"
            end

            operator_class = self.class
            operator_i18n_scope = operator_class.i18n_scope

            operator_class.lookup_ancestors.each do |ancestor|
              # a specific name for a given operator
              defaults << :"#{operator_i18n_scope}.search.operator.ancestors.#{ancestor.model_name.i18n_key}.names.#{name}.examples"
              # a specific operator class
              defaults << :"#{operator_i18n_scope}.search.operator.ancestors.#{ancestor.model_name.i18n_key}.examples"
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
