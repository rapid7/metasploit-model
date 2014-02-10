FactoryGirl.define do
  sequence :metasploit_model_module_class_payload_type, Metasploit::Model::Module::Class::PAYLOAD_TYPES.cycle

  trait :metasploit_model_module_class do
    #
    # Attributes
    #

    # Don't set full_name: before_validation will derive it from {Metasploit::Model::Module::Class#module_type} and
    # {Metasploit::Model::Module::Class::reference_name}.

    ignore do
      # derives from associations in instance, so don't set on instance
      module_type { generate :metasploit_model_module_type }

      # depends on module_type
      # ignored because model attribute will derived from reference_name, this factory attribute is used to generate
      # the correct reference_name.
      payload_type {
        # module_type is factory attribute, not model attribute
        if module_type == Metasploit::Model::Module::Type::PAYLOAD
          generate :metasploit_model_module_class_payload_type
        else
          nil
        end
      }

      #
      # Callback helpers
      #

      before_write_template {
        ->(module_class, evaluator) {}
      }
      write_template {
        ->(module_class, evaluator) {
          if module_class.rank
            module_class.ancestors.each do |module_ancestor|
              # validate to derive attributes
              module_ancestor.valid?

              destination_pathname = module_ancestor.real_pathname

              if destination_pathname
                metasploit_module_relative_name = generate :metasploit_model_module_ancestor_metasploit_module_relative_name

                template = Metasploit::Model::Spec::Template.new(
                    destination_pathname: destination_pathname,
                    locals: {
                        metasploit_module_relative_name: metasploit_module_relative_name,
                        module_ancestor: module_ancestor,
                        module_class: module_class
                    },
                    overwrite: true,
                    search_pathnames: [
                        Pathname.new('module/classes'),
                        Pathname.new('module/ancestors')
                    ],
                    source_relative_name: 'base'
                )
                template.valid!

                template.write
              end
            end
          end
        }
      }
    end

    after(:build) do |module_class, evaluator|
      instance_exec(evaluator, evaluator, &evaluator.before_write_template)
      instance_exec(evaluator, evaluator, &evaluator.write_template)
    end
  end
end