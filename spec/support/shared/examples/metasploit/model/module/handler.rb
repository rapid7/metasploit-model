shared_examples_for 'Metasploit::Model::Module::Handler' do
  it { should be_a Module }

  context 'general_handler_type' do
    subject(:general_handler_type) do
      handler_module.general_handler_type
    end

    it 'should be in Metasploit::Model::Module::Handler::GENERAL_TYPES' do
      general_handler_type.should be_in Metasploit::Model::Module::Handler::GENERAL_TYPES
    end
  end

  context 'handler_type' do
    subject(:handler_type) do
      handler_module.handler_type
    end

    it { should be_a String }
  end
end