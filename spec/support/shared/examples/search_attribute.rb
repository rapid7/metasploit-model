shared_examples_for 'search_attribute' do |name, options={}|
  options.assert_valid_keys(:type)

  type = options.fetch(:type)

  context name do
    subject(:attribute_operator) do
      base_class.search_operator_by_attribute[name]
    end

    its(:type) { should == type }

    context 'help' do
      subject(:help) do
        attribute_operator.help
      end

      context 'with en locale' do
        around(:each) do |example|
          I18n.with_locale(:en) do
            example.run
          end
        end

        it 'should have translation' do
          help.should_not include('translation missing')
        end
      end
    end
  end
end