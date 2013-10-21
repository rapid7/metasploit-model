Metasploit::Model::Spec.shared_examples_for 'Module::Architecture' do
  context 'factories' do
    context module_architecture_factory.to_s do
      subject(module_architecture_factory) do
        FactoryGirl.build(module_architecture_factory)
      end

      it { should be_valid }
    end
  end

  context 'validations' do
    it { should validate_presence_of :architecture }
    it { should validate_presence_of :module_instance }
  end
end