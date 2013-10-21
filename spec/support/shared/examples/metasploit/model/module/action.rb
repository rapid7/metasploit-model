Metasploit::Model::Spec.shared_examples_for 'Module::Action' do
  context 'factories' do
    context module_action_factory do
      let(module_action_factory) do
        FactoryGirl.build(module_action_factory)
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
    it { should validate_presence_of(:module_instance) }
    it { should validate_presence_of(:name) }
  end
end