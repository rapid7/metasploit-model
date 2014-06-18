FactoryGirl.define do
  factory :dummy_module_target,
          :class => Dummy::Module::Target,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_module_target
          ] do
    ignore do
      # have to use module_type from metasploit_model_module_target trait to ensure module_instance will support
      # module targets.
      module_class { FactoryGirl.create(:dummy_module_class, module_type: module_type) }
    end

    module_instance {
      # module_instance MUST be built because it will fail validation without targets
      FactoryGirl.build(
          :dummy_module_instance,
          module_class: module_class,
          # disable module_instance factory's after(:build) from building module_targets since this factory is already
          # building it and if they both build module_targets, then the validations will detect a mismatch.
          targets_length: 0
      )
    }

    after(:build) { |dummy_module_target, evaluator|
      [:architecture, :platform].each do |infix|
        attribute = "target_#{infix.to_s.pluralize}"
        factory = "dummy_module_target_#{infix}"
        length = evaluator.send("#{attribute}_length")

        # factories add selves to associations on dummy_module_target
        FactoryGirl.build_list(
            factory,
            length,
            module_target: dummy_module_target
        )
      end

      module_instance = dummy_module_target.module_instance

      unless module_instance.targets.include? dummy_module_target
        module_instance.targets << dummy_module_target
      end
    }
  end
end