Metasploit::Model::Spec.shared_examples_for 'Module::Reference' do
  context 'factories' do
    context module_reference_factory.to_s do
      subject(module_reference_factory) do
        FactoryGirl.build(module_reference_factory)
      end

      it { should be_valid }
    end
  end

  context 'validations' do
    it { should validate_presence_of :module_instance }
    it { should validate_presence_of :reference }
  end
end