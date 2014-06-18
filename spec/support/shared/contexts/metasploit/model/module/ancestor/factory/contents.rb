shared_context 'Metasploit::Model::Module::Ancestor factory contents' do
  subject(:contents) do
    module_ancestor.contents
  end

  before(:each) do
    # need to validate so that real_path is derived so contents can be read
    module_ancestor.valid?
  end
end