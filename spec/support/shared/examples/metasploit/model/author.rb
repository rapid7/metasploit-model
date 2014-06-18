Metasploit::Model::Spec.shared_examples_for 'Author' do
  context 'factories' do
    context author_factory do
      subject(author_factory) do
        FactoryGirl.build(author_factory)
      end

      it { should be_valid }
    end
  end

  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:name) }
  end

  context 'search' do
    context 'attributes' do
      it_should_behave_like 'search_attribute', :name, :type => :string
    end
  end

  context 'validations' do
    context 'name' do
      it { should validate_presence_of :name }
    end
  end
end