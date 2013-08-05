shared_examples_for 'Metasploit::Model::Module::Author' do
  context 'validations' do
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:module_instance) }
    it { should_not validate_presence_of(:email_address) }
  end
end