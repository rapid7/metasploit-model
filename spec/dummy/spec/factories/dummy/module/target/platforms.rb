FactoryGirl.define do
  factory :dummy_module_target_platform,
          class: Dummy::Module::Target::Platform,
          traits: [
              :metasploit_model_base
          ] do
    association :module_target,
                factory: :dummy_module_target,
                strategy: :build,
                # disable module_target factory from building target_platforms since this factory is already
                # building one
                target_platforms_length: 0

    platform { generate :dummy_platform }

    after(:build) do |module_target_platform|
      module_target = module_target_platform.module_target

      if module_target
        unless module_target.target_platforms.include? module_target_platform
          module_target.target_platforms << module_target_platform
        end

        module_instance = module_target.module_instance
        platform = module_target_platform.platform

        if module_instance && platform
          actual_platform_set = module_instance.module_platforms.map(&:platform)

          unless actual_platform_set.include? platform
            module_instance.module_platforms << FactoryGirl.build(
                :dummy_module_platform,
                module_instance: module_instance,
                platform: platform
            )
          end
        end
      end
    end
  end
end