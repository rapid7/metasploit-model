FactoryGirl.define do
  # Used to test {Metasploit::Model::Module::Ancestor} and to ensure that traits work when used in factories.
  factory :dummy_module_ancestor,
          :class => Dummy::Module::Ancestor,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_module_ancestor
          ] do
    #
    # Associations
    #

    # Dummy::Module::Path does not support save!, so need to make sure strategy is build, which will just use new
    association :parent_path, :factory => :dummy_module_path, :strategy => :build

    #
    # Child Factories
    #

    factory :non_payload_dummy_module_ancestor,
            :traits => [
                :non_payload_metasploit_model_module_ancestor
            ]

    factory :payload_dummy_module_ancestor,
            :traits => [
                :payload_metasploit_model_module_ancestor
            ] do
      factory :single_payload_dummy_module_ancestor,
              :traits => [
                  :single_payload_metasploit_model_module_ancestor
              ]

      factory :stage_payload_dummy_module_ancestor,
              :traits => [
                  :stage_payload_metasploit_model_module_ancestor
              ]

      factory :stager_payload_dummy_module_ancestor,
              :traits => [
                  :stager_payload_metasploit_model_module_ancestor
              ]
    end
  end
end