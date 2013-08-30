shared_examples_for 'Metasploit::Model::Author' do
  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:name) }
  end

  context 'search' do
    context 'i18n_scope' do
      subject(:search_i18n_scope) do
        described_class.search_i18n_scope
      end

      it { should == 'metasploit.model.author' }
    end

    context 'attributes' do
      let(:base_class) do
        author_class
      end

      it_should_behave_like 'search_attribute', :name, :type => :string
    end
  end

  context 'validations' do
    context 'name' do
      it { should validate_presence_of :name }
    end
  end
end