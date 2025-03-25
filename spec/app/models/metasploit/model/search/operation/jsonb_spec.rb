RSpec.describe Metasploit::Model::Search::Operation::Jsonb, type: :model do
  context 'validation' do
    context 'value' do
      before(:example) do
        operation.valid?
      end

      let(:errors) do
        operation.errors[:value]
      end

      let(:operation) do
        described_class.new(:value => value)
      end

      context 'with String' do
        let(:value) do
          'search_string'
        end

        it 'should not record error' do
          expect(errors).to be_empty
        end
      end

      context 'with Integer' do
        let(:value) do
          3
        end

        it 'should not record error' do
          expect(errors).to be_empty
        end
      end

      context 'with a Symbol' do
        let(:value) do
          :mysym
        end

        it 'should not record error' do
          expect(errors).to be_empty
        end
      end
    end
  end

  context '#value' do
    subject(:value) do
      operation.value
    end

    let(:operation) do
      described_class.new(:value => formatted_value)
    end

    context 'with String' do
      let(:formatted_value) do
        'test value'
      end

      it 'should be passed as a String' do
        expect(value).to eq(formatted_value.to_s)
      end
    end

    context 'with Integer' do
      let(:formatted_value) do
        3
      end

      it 'should be passed as a String' do
        expect(value).to eq(formatted_value.to_s)
      end
    end

    context 'with String containing colon characters' do
      {
        'key:value' => '{"key": "value"}',
        'key:value:extra' => '{"key": "value:extra"}',
        '"quoted:part":value' => '{"quoted:part": "value"}',
        '"quoted:part":value:extra' => '{"quoted:part": "value:extra"}',
        'a:b:c:d' => '{"a": "b:c:d"}',
        '"x:y:z":a:b' => '{"x:y:z": "a:b"}',
        "'single:quote':value" => '{"single:quote": "value"}',
        "'single:quote':value:extra" => '{"single:quote": "value:extra"}',
        "'a:b':c:d" => '{"a:b": "c:d"}',
        '"x:y"and"z:w":final' => '{"x:y\"and\"z:w": "final"}',
        "'x:y'and'z:w':final" => '{"x:y\'and\'z:w": "final"}',
        '"a:b":c:"d:e"' => '{"a:b": "c:\"d:e\""}',
        "'a:b':c:'d:e'" => '{"a:b": "c:\'d:e\'"}',
      }.each do |input, expected|

        context "with the string #{input}" do
          let(:formatted_value) { input }

          it 'should be passed as a valid JSON string' do
            expect(value).to eq(expected)
          end
        end

      end

    end
  end
end
