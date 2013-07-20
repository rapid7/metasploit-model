shared_examples_for 'Metasploit::Model::EmailAddress' do
  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:domain) }
    it { should allow_mass_assignment_of(:local) }
  end

  context 'validations' do
    it { should validate_presence_of :domain }
    it { should validate_presence_of :local }
  end
end