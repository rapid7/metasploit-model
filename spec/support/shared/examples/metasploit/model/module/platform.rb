Metasploit::Model::Spec.shared_examples_for 'Module::Platform' do
  context 'factories' do
    context module_platform_factory.to_s do
      subject(module_platform_factory) do
        FactoryGirl.build(module_platform_factory)
      end

      it { should be_valid }
    end
  end

  context 'validations' do
    it { should validate_presence_of :module_instance }
    it { should validate_presence_of :platform }
  end
end