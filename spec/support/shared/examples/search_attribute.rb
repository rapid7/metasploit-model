shared_examples_for 'search_attribute' do |name, options={}|
  options.assert_valid_keys(:type)

  it_should_behave_like 'search_with',
                        Metasploit::Model::Search::Operator::Attribute,
                        :attribute => name,
                        :name => name,
                        :type => options.fetch(:type)
end