require 'spec_helper'

describe Metasploit::Model::Search::Query do
  context 'validations' do
    it { should validate_presence_of :klass }

    context 'operations' do
      let(:errors) do
        query.errors[:operations]
      end

      let(:klass) do
        Class.new
      end

      let(:query) do
        described_class.new(
            :formatted => formatted,
            :klass => klass
        )
      end

      before(:each) do
        stub_const('Queried', klass)

        # include after stubbing constant so that Class#name can be used for search_i18n_scope
        klass.send(:include, Metasploit::Model::Search)
      end

      context 'length' do
        let(:error) do
          I18n.translate('errors.messages.too_short', :count => 1)
        end

        before(:each) do
          query.valid?
        end

        context 'with empty' do
          let(:formatted) do
            ''
          end

          it 'should have no operations' do
            query.operations.length.should == 0
          end

          it 'should record error on operations' do
            errors.should include(error)
          end
        end

        context 'without empty' do
          let(:formatted) do
            'formatted_operator:formatted_value'
          end

          it 'should not record error on operations' do
            errors.should_not include(error)
          end
        end
      end

      context 'valid' do
        let(:error) do
          'is invalid'
        end

        let(:query) do
          described_class.new
        end

        before(:each) do
          operation = double('Invalid Operation', :valid? => valid)
          query.stub(:operations).and_return([operation])
        end

        context 'with invalid operation' do
          let(:valid) do
            false
          end

          it 'should record error on operations' do
            errors.should_not include(error)
          end
        end

        context 'without invalid operation' do
          let(:valid) do
            true
          end

          it 'should not record error on options' do
            errors.should_not include(error)
          end
        end
      end
    end
  end

  context 'formatted_operations' do
    subject(:formatted_operations) do
      described_class.formatted_operations(formatted_query)
    end

    context 'with quoted value' do
      let(:formatted_query) do
        # embedded : in quotes to make sure it's not be being split on words around each :.
        'formatted_operator1:"formatted value:1" formatted_operator2:formatted_value2'
      end

      it 'should parse the correct number of formatted_operations' do
        expect(formatted_operations.length).to eq(2)
      end

      it 'should include operation with space in value' do
        formatted_operations.should include('formatted_operator1:formatted value:1')
      end

      it 'should include operation without space in value' do
        formatted_operations.should include('formatted_operator2:formatted_value2')
      end
    end

    context 'with unquoted value' do
      let(:expected_formatted_operations) do
        [
            'formatted_operator1:formatted_value1',
            'formatted_operator2:formatted_value2'
        ]
      end

      let(:formatted_query) do
        expected_formatted_operations.join(' ')
      end

      it 'should parse correct number of formatted operations' do
        expect(formatted_operations.length).to eq(expected_formatted_operations.length)
      end

      it 'should include all formatted operations' do
        expect(formatted_operations).to match_array(expected_formatted_operations)
      end
    end

    context 'with nil' do
      let(:formatted_operations) do
        nil
      end

      it { be_empty }
    end
  end

  context '#operations' do
    subject(:operations) do
      query.operations
    end

    let(:attribute) do
      :searchable
    end

    let(:formatted) do
      "#{formatted_operator}:#{formatted_value}"
    end

    let(:formatted_operator) do
      ''
    end

    let(:formatted_value) do
      ''
    end

    let(:klass) do
      Class.new
    end

    let(:query) do
      described_class.new(
          :formatted => formatted,
          :klass => klass
      )
    end

    before(:each) do
      stub_const('QueriedClass', klass)

      # include after stubbing const so that search_i18n_scope can use Class#name
      klass.send(:include, Metasploit::Model::Search)
    end

    it 'should parse #formatted with formatted_operations' do
      described_class.should_receive(:formatted_operations).with(formatted).and_return([])

      operations
    end

    context 'with known operator' do
      subject(:operator) do
        operations.first
      end

      let(:formatted_operator) do
        @operator.name
      end

      let(:formatted_value) do
        ''
      end

      before(:each) do
        @operator = klass.search_attribute attribute, :type => type
      end

      context 'with boolean operator' do
        let(:type) do
          :boolean
        end

        it { should be_a Metasploit::Model::Search::Operation::Boolean }

        context "with 'true'" do
          let(:formatted_value) do
            'true'
          end

          it { should be_valid }
        end

        context "with 'false'" do
          let(:formatted_value) do
            'false'
          end

          it { should be_valid }
        end

        context "without 'false' or 'true'" do
          let(:formatted_value) do
            'no'
          end

          it { should_not be_valid }
        end
      end

      context 'with date operator' do
        let(:type) do
          :date
        end

        it { should be_a Metasploit::Model::Search::Operation::Date }

        context 'with date' do
          let(:formatted_value) do
            Date.today.to_s
          end

          it { should be_valid }
        end

        context 'without date' do
          let(:formatted_value) do
            'yesterday'
          end

          it { should_not be_valid }
        end
      end

      context 'with integer operator' do
        let(:type) do
          :integer
        end

        it { should be_a Metasploit::Model::Search::Operation::Integer }

        context 'with integer' do
          let(:formatted_value) do
            '100'
          end

          it { should be_valid }
        end

        context 'with float' do
          let(:formatted_value) do
            '100.5'
          end

          it { should be_invalid }
        end

        context 'with integer embedded in text' do
          let(:formatted_value) do
            'a2c'
          end

          it { should be_invalid }
        end
      end

      context 'with string operator' do
        let(:type) do
          :string
        end

        it { should be_a Metasploit::Model::Search::Operation::String }

        context 'with value' do
          let(:formatted_value) do
            'formatted_value'
          end

          it { should be_valid }
        end

        context 'without value' do
          let(:formatted_value) do
            ''
          end

          it { should_not be_valid }
        end
      end
    end

    context 'without known operator' do
      subject(:operation) do
        operations.first
      end

      let(:formatted_operator) do
        'unknown_operator'
      end

      let(:formatted_value) do
        'unknown_value'
      end

      it { should be_a Metasploit::Model::Search::Operation::Base }

      it { should be_invalid }
    end
  end

  context '#parse_operator' do
    subject(:parse_operator) do
      query.parse_operator(formatted_operator)
    end

    let(:attribute) do
      :searched
    end

    let(:klass) do
      Class.new
    end

    let(:query) do
      described_class.new(
          :klass => klass
      )
    end

    before(:each) do
      stub_const('QueriedClass', klass)

      # include after stubbing const so that search_i18n_scope can use Class#name
      klass.send(:include, Metasploit::Model::Search)
      @operator = klass.search_attribute attribute, :type => :string
    end

    context 'with operator name' do
      let(:formatted_operator) do
        attribute.to_s
      end

      context 'with String' do
        it 'should find operator' do
          parse_operator.should == @operator
        end
      end

      context 'with Symbol' do
        let(:formatted_operator) do
          attribute
        end

        it 'should find operator' do
          parse_operator.should == @operator
        end
      end
    end

    context 'without operator name' do
      let(:formatted_operator) do
        'unknown_operator'
      end

      it { should be_a Metasploit::Model::Search::Operator::Null }
    end
  end
end