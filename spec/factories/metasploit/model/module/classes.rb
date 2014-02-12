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
          Metasploit::Model::Module::Class::Spec::Template.write(module_class: module_class)
        }
      }
    end

    after(:build) do |module_class, evaluator|
      instance_exec(evaluator, evaluator, &evaluator.before_write_template)
      instance_exec(evaluator, evaluator, &evaluator.write_template)
    end
  end
end