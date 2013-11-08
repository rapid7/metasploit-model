FactoryGirl.define do
  factory_by_attribute = {
      actions: :dummy_module_action,
      module_references: :dummy_module_reference,
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
      if stanced?
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
          if dummy_module_instance.allows?(attribute)
            length = evaluator.send("#{attribute}_length")

            collection = length.times.collect {
              FactoryGirl.build(factory, module_instance: dummy_module_instance)
            }

            dummy_module_instance.send("#{attribute}=", collection)
          end
        end

        # make sure targets are generated first so that module_architectures and module_platforms can be include
        # the targets' architectures and platforms.
        if dummy_module_instance.allows?(:targets)
          # factory adds built module_targets to module_instance.
          FactoryGirl.build_list(
              :dummy_module_target,
              evaluator.targets_length,
              module_instance: dummy_module_instance
          )
          # module_architectures and module_platforms will be derived from targets
        else
          # if there are no targets, then architectures and platforms need to be explicitly defined on module instance
          # since they can't be derived from anything
          [:architecture, :platform].each do |suffix|
            attribute = "module_#{suffix.to_s.pluralize}".to_sym

            if dummy_module_instance.allows?(attribute)
              factory = "dummy_module_#{suffix}"
              length = evaluator.send("#{attribute}_length")

              collection = FactoryGirl.build_list(
                  factory,
                  length,
                  module_instance: dummy_module_instance
              )
              dummy_module_instance.send("#{attribute}=", collection)
            end
          end
        end
      end
    end
  end
end