shared_examples_for 'search query with Metasploit::Model::Search::Operator::Deprecated::Authority' do |options={}|
  options.assert_valid_keys(:formatted_operator)

  formatted_operator = options.fetch(:formatted_operator)

  context "with #{formatted_operator}" do
    subject(:query) do
      Metasploit::Model::Search::Query.new(
          :formatted => formatted,
          :klass => base_class
      )
    end

    let(:formatted) do
      "#{formatted_operator}:\"#{formatted_value}\""
    end

    let(:formatted_value) do
      FactoryGirl.generate :metasploit_model_reference_designation
    end

    context 'operations' do
      subject(:operations) do
        query.operations
      end

      def operation_with_formatted_operator(formatted_operator)
        operator_name = formatted_operator.to_sym

        operations.find { |operation|
          operation.operator.name == operator_name
        }
      end

      context 'authoritities.abbreviation' do
        subject(:operation) do
          operation_with_formatted_operator('authorities.abbreviation')
        end

        its(:value) { should == formatted_operator }
      end

      context 'references.designation' do
        subject(:operation) do
          operation_with_formatted_operator('references.designation')
        end

        context 'value' do
          subject(:value) do
            operation.value
          end

          it 'should be formatted value' do
            value.should == formatted_value
          end
        end
      end
    end
  end
end
