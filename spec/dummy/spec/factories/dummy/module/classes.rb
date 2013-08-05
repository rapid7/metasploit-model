FactoryGirl.define do
  factory :dummy_module_class,
          :class => Dummy::Module::Class,
          :traits => [
              :metasploit_model_base,
              :metasploit_model_module_class
          ] do
    #
    # Associations
    #

    # depends on module_type and payload_type
    ancestors {
      ancestors  = []

      # ignored attribute from factory; NOT the instance attribute
      case module_type
        when 'payload'
          # ignored attribute from factory; NOT the instance attribute
          case payload_type
            when 'single'
              ancestors << FactoryGirl.create(:single_payload_dummy_module_ancestor)
            when 'staged'
              ancestors << FactoryGirl.create(:stage_payload_dummy_module_ancestor)
              ancestors << FactoryGirl.create(:stager_payload_dummy_module_ancestor)
            else
              raise ArgumentError,
                    "Don't know how to create Dummy::Module::Class#ancestors " \
                    "for Dummy::Module::Class#payload_type (#{payload_type})"
          end
        else
          ancestors << FactoryGirl.create(:dummy_module_ancestor, :module_type => module_type)
      end

      ancestors
    }

    rank { generate :dummy_module_rank }
  end
end