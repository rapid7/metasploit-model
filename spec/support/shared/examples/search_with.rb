shared_examples_for 'search_with' do |operation_class, options={}|
  name = options.fetch(:name)

  context name do
    subject(:with_operator) do
      base_class.search_with_operator_by_name[name]
    end

    it { should be_a operation_class }

    options.each do |key, value|
      # skip :name since it use used to look up operator, so it's already been checked or with_operator would be `nil`
      unless key == :name
        its(key) { should == value }
      end
    end

    context 'help' do
      subject(:help) do
        with_operator.help
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