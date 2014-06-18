Metasploit::Model::Spec.shared_examples_for 'Module::Target::Architecture' do
  context 'factories' do
    context module_target_architecture_factory do
      subject(module_target_architecture_factory) do
        FactoryGirl.build(module_target_architecture_factory)
      end

      it { should be_valid }

      context '#module_target' do
        subject(:module_target) do
          send(module_target_architecture_factory).module_target
        end

        it { should be_valid }

        context '#module_instance' do
          subject(:module_instance) do
            module_target.module_instance
          end

          it { should be_valid }

          context '#targets' do
            subject(:targets) do
              module_instance.targets
            end

            its(:length) { should == 1 }

            it 'should include #module_target' do
              expect(targets).to include module_target
            end
          end
        end

        context '#target_architectures' do
          subject(:target_architectures) do
            module_target.target_architectures
          end

          its(:length) { should == 1}

          it "should include #{module_target_architecture_factory}" do
            expect(target_architectures).to include send(module_target_architecture_factory)
          end
        end
      end
    end
  end

  context 'validations' do
    it { should validate_presence_of :architecture }
    it { should validate_presence_of :module_target }
  end
end