FactoryGirl.define do
  sequence :metasploit_model_module_ancestor_module_type, Metasploit::Model::Module::Ancestor::MODULE_TYPES.cycle

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
end