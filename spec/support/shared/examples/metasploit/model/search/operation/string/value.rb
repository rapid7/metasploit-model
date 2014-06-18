shared_examples_for 'Metasploit::Model::Search::Operation::String::Value' do
  let(:operation_class) do
    described_class
  end

  context '#class' do
    subject do
      operation_class
    end

    it { should include Metasploit::Model::Search::Operation::String::Value }
  end

  context '#value' do
    subject(:value) do
      operation.value
    end

    let(:operation) do
      operation_class.new(:value => formatted_value)
    end

    context 'with Integer' do
      let(:formatted_value) do
        5
      end

      it 'should convert to String' do
        value.should == '5'
      end
    end

    context 'with String' do
      let(:formatted_value) do
        'a string'
      end

      it 'should pass through String' do
        value.should == formatted_value
      end
    end

    context 'with Symbol' do
      let(:formatted_value) do
        :a_symbol
      end

      it 'should convert to String' do
        value.should == 'a_symbol'
      end
    end
  end
end