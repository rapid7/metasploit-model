Metasploit::Model::Spec.shared_examples_for 'Module::Platform' do
  context 'factories' do
    context module_platform_factory.to_s do
      subject(module_platform_factory) do
        FactoryGirl.build(module_platform_factory)
      end

      it { should be_valid }

      context '#module_instance' do
        subject(:module_instance) do
          send(module_platform_factory).module_instance
        end

        it { should be_valid }

        context '#module_platforms' do
          subject(:module_platforms) do
            module_instance.module_platforms
          end

          its(:length) { should == 1 }

          it "should include #{module_platform_factory}" do
            expect(module_platforms).to include send(module_platform_factory)
          end
        end
      end
    end
  end

  context 'validations' do
    it { should validate_presence_of :module_instance }
    it { should validate_presence_of :platform }
  end
end