shared_examples_for 'Metasploit::Model::Module::Target' do
  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:index) }
    it { should allow_mass_assignment_of(:name) }
  end

  context 'validations' do
    it { should validate_presence_of(:index) }
    it { should validate_presence_of(:module_instance) }
    it { should validate_presence_of(:name) }
  end
end