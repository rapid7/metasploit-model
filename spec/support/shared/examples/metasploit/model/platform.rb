shared_examples_for 'Metasploit::Model::Platform' do
  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end