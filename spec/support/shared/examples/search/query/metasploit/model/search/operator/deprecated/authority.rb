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

        context 'Metasploit::Model::Search::Operation::Association#source_operation' do
          subject(:source_operation) {
            operation.source_operation
          }

          context 'Metasploit::Model::Search::Operation::Base#value' do
            subject(:value) {
              source_operation.value
            }

            it { should == formatted_operator }
          end
        end
      end

      context 'references.designation' do
        subject(:operation) do
          operation_with_formatted_operator('references.designation')
        end

        context 'Metasploit::Model::Search::Operation::Association#source_operation' do
          subject(:source_operation) {
            operation.source_operation
          }

          it 'uses formatted value for value' do
            expect(source_operation.value).to eq(formatted_value)
          end
        end
      end
    end
  end
end
