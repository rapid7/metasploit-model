shared_examples_for 'Metasploit::Model::Author' do
  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:name) }
  end

  context 'validations' do
    context 'name' do
      it { should validate_presence_of :name }
    end
  end
end