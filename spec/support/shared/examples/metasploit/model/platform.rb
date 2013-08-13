shared_examples_for 'Metasploit::Model::Platform' do
  context 'search' do
    context 'i18n_scope' do
      subject(:search_i18n_scope) do
        described_class.search_i18n_scope
      end

      it { should == 'metasploit.model.platform' }
    end

    context 'attributes' do
      let(:base_class) do
        platform_class
      end

      it_should_behave_like 'search_attribute', :name, :type => :string
    end
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end