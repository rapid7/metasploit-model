shared_examples_for 'search_association' do |association|
  context association do
    let(:association_operators) do
      base_class.search_operator_by_name.select { |_name, operator|
        operator.respond_to?(:association) and operator.association == association
      }
    end

    it 'should have operators for association' do
      association_operators.should_not be_empty
    end
  end
end