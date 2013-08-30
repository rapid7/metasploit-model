shared_examples_for 'Metasploit::Model::Module::Target' do
  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:index) }
    it { should allow_mass_assignment_of(:name) }
  end

  context 'search' do
    context 'search_i18n_scope' do
      subject(:search_i18n_scope) do
        described_class.search_i18n_scope
      end

      it { should == 'metasploit.model.module.target' }
    end

    context 'attributes' do
      it_should_behave_like 'search_attribute', :name, :type => :string
    end
  end

  context 'validations' do
    it { should validate_presence_of(:index) }
    it { should validate_presence_of(:module_instance) }
    it { should validate_presence_of(:name) }
  end
end