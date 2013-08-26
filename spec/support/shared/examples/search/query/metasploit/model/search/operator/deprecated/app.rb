shared_examples_for 'search query with Metasploit::Model::Search::Operator::Deprecated::App' do
  context 'with app' do
    subject(:query) do
      Metasploit::Model::Search::Query.new(
          :formatted => formatted,
          :klass => base_class
      )
    end

    let(:formatted) do
      "app:#{formatted_value}"
    end

    context 'operations' do
      subject(:operations) do
        query.operations
      end

      context 'stance' do
        subject(:operation) do
          operations.find { |operation|
            operation.operator.name == :stance
          }
        end

        context 'with client' do
          let(:formatted_value) do
            'client'
          end

          its(:value) { should == 'passive' }
        end

        context 'with server' do
          let(:formatted_value) do
            'server'
          end

          its(:value) { should == 'aggressive' }
        end
      end
    end
  end
end