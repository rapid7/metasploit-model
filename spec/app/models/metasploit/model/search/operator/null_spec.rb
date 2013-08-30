require 'spec_helper'

describe Metasploit::Model::Search::Operator::Null do
  subject(:operator) do
    described_class.new
  end

  it { should be_a Metasploit::Model::Search::Operator::Single }

  context 'validations' do
    context 'name' do
      let(:error) do
        I18n.translate('activemodel.errors.models.metasploit/model/search/operator/null.attributes.name.unknown')
      end

      before(:each) do
        operator.valid?
      end

      it 'should record error' do
        operator.errors[:name].should include(error)
      end
    end
  end

  context '#type' do
    subject(:type) do
      operator.type
    end

    it { should be_nil }
  end

  context '#operation_class' do
    subject(:operation_class) do
      operator.send(:operation_class)
    end

    it { should == Metasploit::Model::Search::Operation::Null }
  end
end