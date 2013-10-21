FactoryGirl.define do
  factory_by_attribute = {
      actions: :dummy_module_action,
      module_architectures: :dummy_module_architecture,
      module_platforms: :dummy_module_platform,
      module_references: :dummy_module_reference,
      targets: :dummy_module_target
  }

  factory :dummy_module_instance,
          :class => Dummy::Module::Instance,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_module_instance
          ] do
    #
    # Associations
    #

    association :module_class, :factory => :dummy_module_class

    # attribute must be called after association is created so that support_stance? has access to module_class
    # needs to be declared explicitly after association as calling trait here (instead as an argument to factory
    # :traits) did not work.
    stance {
      if supports?(:stance)
        generate :metasploit_model_module_stance
      else
        nil
      end
    }

    # needs to be an after(:build) and not an after(:create) to ensure counted associations are populated before being
    # validated.
    after(:build) do |dummy_module_instance, evaluator|
      dummy_module_instance.module_authors = evaluator.module_authors_length.times.collect {
        FactoryGirl.build(:dummy_module_author, module_instance: dummy_module_instance)
      }

      module_class = dummy_module_instance.module_class

      # only attempt to build supported associations if the module_class is valid because supports depends on a valid
      # module_type and validating the module_class will derive module_type.
      if module_class && module_class.valid?
        factory_by_attribute.each do |attribute, factory|
          if dummy_module_instance.supports?(attribute)
            length = evaluator.send("#{attribute}_length")

            collection = length.times.collect {
              FactoryGirl.build(factory, module_instance: dummy_module_instance)
            }

            dummy_module_instance.send("#{attribute}=", collection)
          end
        end
      end
    end
  end
end