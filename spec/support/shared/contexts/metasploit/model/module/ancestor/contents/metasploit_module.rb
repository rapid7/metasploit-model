shared_context 'Metasploit::Model::Module::Ancestor#contents metasploit_module' do
  def namespace_module_metasploit_module(namespace_module)
    constant = namespace_module_metasploit_module_constant(namespace_module)
    namespace_module.const_get(constant)
  end

  def namespace_module_metasploit_module_constant(namespace_module)
    namespace_module.constants.find { |constant|
      constant.to_s =~ /Metasploit\d+/
    }
  end
end
