shared_examples_for 'Metasploit::Model::Module::Instance' do
  context 'CONSTANTS' do
    context 'PRIVILEGES' do
      subject(:privileges) do
        described_class::PRIVILEGES
      end

      it 'should contain both Boolean values' do
        privileges.should include(false)
        privileges.should include(true)
      end
    end

    context 'STANCES' do
      subject(:stances) do
        described_class::STANCES
      end

      it { should include('aggressive') }
      it { should include('passive') }
    end
  end

  context 'validations' do
    it { should validate_presence_of :module_class }

    context 'ensure inclusion of privileged is boolean' do
      let(:error) do
        'is not included in the list'
      end

      before(:each) do
        module_instance.privileged = privileged

        module_instance.valid?
      end

      context 'with nil' do
        let(:privileged) do
          nil
        end

        it 'should record error' do
          module_instance.errors[:privileged].should include(error)
        end
      end

      context 'with false' do
        let(:privileged) do
          false
        end

        it 'should not record error' do
          module_instance.errors[:privileged].should be_empty
        end
      end

      context 'with true' do
        let(:privileged) do
          true
        end

        it 'should not record error' do
          module_instance.errors[:privileged].should be_empty
        end
      end
    end

    context 'stance' do
      context 'module_type' do
        subject(:module_instance) do
          FactoryGirl.build(
              module_instance_factory,
              :module_class => module_class,
              # set by shared examples
              :stance => stance
          )
        end

        let(:module_class) do
          FactoryGirl.create(
              module_class_factory,
              # set by shared examples
              :module_type => module_type
          )
        end

        let(:stance) do
          nil
        end

        it_should_behave_like 'Metasploit::Model::Module::Instance supports stance with module_type', 'auxiliary'
        it_should_behave_like 'Metasploit::Model::Module::Instance supports stance with module_type', 'exploit'

        it_should_behave_like 'Metasploit::Model::Module::Instance does not support stance with module_type', 'encoder'
        it_should_behave_like 'Metasploit::Model::Module::Instance does not support stance with module_type', 'nop'
        it_should_behave_like 'Metasploit::Model::Module::Instance does not support stance with module_type', 'payload'
        it_should_behave_like 'Metasploit::Model::Module::Instance does not support stance with module_type', 'post'
      end
    end
  end
end