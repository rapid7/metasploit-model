shared_examples_for 'Metasploit::Model::EmailAddress' do
  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:domain) }
    it { should allow_mass_assignment_of(:local) }
  end

  context 'search' do
    context 'i18n_scope' do
      subject(:search_i18n_scope) do
        described_class.search_i18n_scope
      end

      it { should == 'metasploit.model.email_address' }
    end

    context 'attributes' do
      let(:base_class) do
        email_address_class
      end

      it_should_behave_like 'search_attribute', :domain, :type => :string
      it_should_behave_like 'search_attribute', :local, :type => :string
    end
  end

  context 'validations' do
    it { should validate_presence_of :domain }
    it { should validate_presence_of :local }
  end
end