
Metasploit::Model::Spec.shared_examples_for 'Module::Target' do
  context 'factories' do
    context module_target_factory do
      subject(module_target_factory) do
        FactoryGirl.build(module_target_factory)
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
    it { should validate_presence_of :target_architectures }
    it { should validate_presence_of :target_platforms }
  end
end