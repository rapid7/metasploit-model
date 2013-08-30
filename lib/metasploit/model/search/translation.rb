module Metasploit
  module Model
    module Search
      # Extend this module to register the key prefix used to look up the translation for search operator help strings.
      # The {Metasploit::Model::Search::Translation#search_i18n_scope} will be automatically derived from
      # name of the class that extends this module.
      #
      # @example Register 'metasploit.model.module.instance' as search_translation_key_prefix for Metasploit::Model::Module::Instance
      #   module Metasploit
      #     module Model
      #       module Module
      #         module Instance
      #           extend Metasploit::Model::Search::Translation
      #         end
      #       end
      #     end
      #   end
      #
      #   Metasploit::Model::Module::Instance.search_translation_key_prefix # 'metasploit.model.module.instance'
      #
      module Translation
        # Automatically derives {#search_i18n_scope} from `base` `Module#name`.
        #
        # @param base [Module] module that extended this module.
        # @return [void]
        def self.extended(base)
          super

          base.search_i18n_scope
        end

        # The prefix for `I18n.translate` calls to generate the help for attribute operators.
        #
        # @return [String]
        def search_i18n_scope
          unless instance_variable_defined? :@search_i18n_scope
            search_translation_ancestor = ancestors.find { |ancestor|
              ancestor != self and ancestor.respond_to? :search_i18n_scope
            }

            if search_translation_ancestor
              @search_i18n_scope = search_translation_ancestor.search_i18n_scope
            else
              @search_i18n_scope = name.gsub('::', '.').underscore
            end
          end

          @search_i18n_scope
        end
      end
    end
  end
end