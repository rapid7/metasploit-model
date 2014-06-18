shared_context 'Metasploit::Model::Module::Ancestor factory contents metasploit_module' do
  include_context 'Metasploit::Model::Module::Ancestor#contents metasploit_module'

  subject(:metasploit_module) do
    namespace_module_metasploit_module(namespace_module)
  end

  let(:namespace_module) do
    Module.new
  end

  before(:each) do
    namespace_module.module_eval(contents)
  end
end