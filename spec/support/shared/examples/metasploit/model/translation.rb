shared_examples_for 'Metasploit::Model::Translation' do |options={}|
  options.assert_valid_keys(:metasploit_model_ancestor)

  metasploit_model_ancestor = options.fetch(:metasploit_model_ancestor)

  it 'should include Metasploit::Model::Translation' do
    base_class.should include Metasploit::Model::Translation
  end

  context 'i18n_scope' do
    subject(:i18n_scope) do
      base_class.i18n_scope
    end

    it { should == 'metasploit.model' }
  end

  context 'lookup_ancestors' do
    subject(:lookup_ancestors) do
      base_class.lookup_ancestors
    end

    it { should include metasploit_model_ancestor }
  end
end