FactoryGirl.define do
  sequence :metasploit_model_module_ancestor_handler_type do |n|
    "metasploit_model_module_ancestor_handler_type#{n}"
  end

  sequence :metasploit_model_module_ancestor_module_type, Metasploit::Model::Module::Type::ALL.cycle

  non_payload_ordered_types = Metasploit::Model::Module::Type::ALL - ['payload']
  sequence :metasploit_model_module_ancestor_non_payload_module_type, non_payload_ordered_types.cycle

  sequence :metasploit_model_module_ancestor_payload_type, Metasploit::Model::Module::Ancestor::PAYLOAD_TYPES.cycle

  sequence :metasploit_model_module_ancestor_reference_name do |n|
    [
        'metasploit',
        'model',
        'module',
        'ancestor',
        'reference',
        "name#{n}"
    ].join('/')
  end

  sequence :metasploit_model_module_ancestor_non_payload_reference_name do |n|
    [
        'mdm',
        'module',
        'ancestor',
        'non',
        'payload',
        'reference',
        "name#{n}"
    ].join('/')
  end

  payload_type_directories = Metasploit::Model::Module::Ancestor::PAYLOAD_TYPES.map(&:pluralize)

  sequence :metasploit_model_module_ancestor_payload_reference_name do |n|
    payload_type_directory = payload_type_directories[n % payload_type_directories.length]

    [
        payload_type_directory,
        'metasploit',
        'model',
        'module',
        'ancestor',
        'payload',
        'reference',
        "name#{n}"
    ].join('/')
  end

  sequence :metasploit_model_module_ancestor_relative_payload_name do |n|
    [
        'metasploit',
        'model',
        'module',
        'ancestor',
        'relative',
        'payload',
        "name#{n}"
    ].join('/')
  end

  trait :metasploit_model_module_ancestor do
    #
    # Attributes
    #

    module_type { generate :metasploit_model_module_ancestor_module_type }

    ignore do
      # depends on module_type
      payload_type {
        if payload?
          generate :metasploit_model_module_ancestor_payload_type
        else
          nil
        end
      }
    end

    # depends on module_type
    reference_name {
      if payload?
        payload_type_directory = payload_type.pluralize
        relative_payload_name = generate :metasploit_model_module_ancestor_relative_payload_name

        [
            payload_type_directory,
            relative_payload_name
        ].join('/')
      else
        generate :metasploit_model_module_ancestor_non_payload_reference_name
      end
    }

    # depends on derived_payload_type which depends on reference_name
    handler_type {
      # can't use #handled? because it will check payload_type on model, not ignored field in factory, so use
      # .handled?
      if @instance.class.handled?(:module_type => module_type, :payload_type => derived_payload_type)
        generate :metasploit_model_module_ancestor_handler_type
      else
        nil
      end
    }

    #
    # Callbacks
    #

    after(:build) do |ancestor|
      path = ancestor.derived_real_path

      if path
        pathname = Pathname.new(path)
        Metasploit::Model::Spec::PathnameCollision.check!(pathname)
        # make directory
        pathname.parent.mkpath

        # make file
        pathname.open('w') do |f|
          f.puts "# Module Type: #{ancestor.module_type}"
          f.puts "# Reference Name: #{ancestor.reference_name}"
        end
      end
    end
  end

  trait :non_payload_metasploit_model_module_ancestor do
    module_type { generate :metasploit_model_module_ancestor_non_payload_module_type }

    ignore do
      payload_type nil
    end
  end

  trait :payload_metasploit_model_module_ancestor do
    module_type 'payload'

    ignore do
      payload_type { generate :metasploit_model_module_ancestor_payload_type }
    end

    reference_name {
      payload_type_directory = payload_type.pluralize
      relative_payload_name = generate :metasploit_model_module_ancestor_relative_payload_name

      [
          payload_type_directory,
          relative_payload_name
      ].join('/')
    }
  end

  trait :single_payload_metasploit_model_module_ancestor do
    ignore do
      payload_type 'single'
    end
  end

  trait :stage_payload_metasploit_model_module_ancestor do
    ignore do
      payload_type 'stage'
    end
  end

  trait :stager_payload_metasploit_model_module_ancestor do
    ignore do
      payload_type 'stager'
    end
  end
end