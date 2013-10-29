Metasploit::Model::Spec.shared_examples_for 'Module::Architecture' do
  context 'factories' do
    context module_architecture_factory.to_s do
      subject(module_architecture_factory) do
        FactoryGirl.build(module_architecture_factory)
      end

      it { should be_valid }

      context '#module_instance' do
        subject(:module_instance) do
          send(module_architecture_factory).module_instance
        end

        it { should be_valid }

        context '#module_architectures' do
          subject(:module_architectures) do
            module_instance.module_architectures
          end

          its(:length) { should == 1 }

          it "should include #{module_architecture_factory}" do
            expect(module_architectures).to include send(module_architecture_factory)
          end
        end
      end
    end
  end

  context 'validations' do
    it { should validate_presence_of :architecture }
    it { should validate_presence_of :module_instance }
  end
end