FactoryGirl.define do
  sequence :metasploit_model_module_instance_description do |n|
    "Module Description #{n}"
  end

  sequence :metasploit_model_module_instance_disclosed_on do |n|
    Date.today - n
  end

  sequence :metasploit_model_module_instance_license do |n|
    "Module License #{n}"
  end

  sequence :metasploit_model_module_instance_name do |n|
    "Module Name #{n}"
  end

  sequence :metasploit_model_module_instance_privileged, Metasploit::Model::Module::Instance::PRIVILEGES.cycle

  total_architectures = Metasploit::Model::Architecture::ABBREVIATIONS.length
  total_platforms = Metasploit::Model::Platform.fully_qualified_name_set.length
  # chosen so that there is at least 1 element even if 0 is allowed so that factories always test that the associated
  # records are handled.
  minimum_with_elements = 1
  # arbitrarily chosen maximum when there are a bounded total of the associated records.  Most chosen because 3 will
  # test that there is no 1 or 2 special casing make it work.
  arbitrary_maximum = 3
  arbitrary_supported_length = ->{
    Random.rand(minimum_with_elements .. arbitrary_maximum)
  }

  trait :metasploit_model_module_instance do
    ignore do
      actions_length(&arbitrary_supported_length)

      # this length is only used if supports?(:module_architectures) is true.  It can be set to 0 when
      # supports?(:module_architectures) is true to make the after(:build) skip building the module architectures automatically.
      module_architectures_length {
        Random.rand(minimum_with_elements .. total_architectures)
      }

      module_authors_length(&arbitrary_supported_length)

      # this length is only used if supports?(:module_platforms) is true.  It can be set to 0 when
      # supports?(:module_platforms) is true to make the after(:build) skip building the module platforms automatically.
      module_platforms_length {
        Random.rand(minimum_with_elements .. total_platforms)
      }

      module_references_length(&arbitrary_supported_length)
      targets_length(&arbitrary_supported_length)

      #
      # Callback helpers
      #

      # Can't use the after(:build) system because in Mdm, the associations need to be set before writing the template
      before_write_template {
        ->(module_instance, _evaluator){}
      }
      write_template {
        ->(module_instance, _evaluator) {
          Metasploit::Model::Module::Instance::Spec::Template.write(module_instance: module_instance)
        }
      }
    end

    #
    # Attributes
    #

    description { generate :metasploit_model_module_instance_description }
    disclosed_on { generate :metasploit_model_module_instance_disclosed_on }
    license { generate :metasploit_model_module_instance_license }
    name { generate :metasploit_model_module_instance_name }
    privileged { generate :metasploit_model_module_instance_privileged }

    after(:build) do |module_instance, evaluator|
      instance_exec(module_instance, evaluator, &evaluator.before_write_template)
      instance_exec(module_instance, evaluator, &evaluator.write_template)
    end
  end
end
