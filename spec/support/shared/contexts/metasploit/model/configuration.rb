shared_context 'Metasploit::Model::Configuration' do
  let(:configuration) do
    Metasploit::Model::Configuration.new.tap { |configuration|
      configuration.root = root
    }
  end

  let(:root) do
    Metasploit::Model.root.join('spec', 'dummy')
  end
end