shared_context 'Metasploit::Model::Module::Ancestor factory contents metasploit_module' do
  subject(:metasploit_module) do
    namespace_module.const_get(metasploit_module_constant)
  end

  let(:metasploit_module_constant) do
    namespace_module.constants.find { |constant|
      constant.to_s =~ /Metasploit\d+/
    }
  end

  let(:namespace_module) do
    Module.new
  end

  before(:each) do
    namespace_module.module_eval(contents)
  end
end