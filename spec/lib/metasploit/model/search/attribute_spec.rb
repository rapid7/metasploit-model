require 'spec_helper'

describe Metasploit::Model::Search::Attribute do
  subject(:base_class) do
    described_class = self.described_class

    Class.new do
      include described_class
    end
  end

  context 'search_attribute' do
    context 'with attribute' do
      let(:attribute) do
        FactoryGirl.generate :metasploit_model_search_operator_attribute_attribute
      end

      context 'with :type' do
        let(:type) do
          FactoryGirl.generate :metasploit_model_search_operator_attribute_type
        end

        context 'operator' do
          subject(:operator) do
            base_class.search_attribute attribute, :type => type
          end

          it 'should call search_with' do
            base_class.should_receive(:search_with).with(
                Metasploit::Model::Search::Operator::Attribute,
                hash_including(
                    :attribute => attribute,
                    :type => type
                )
            )

            operator
          end

          it 'should be in search_attribute_operator_by_attribute' do
            # grab operator first since it calls search_attribute and populates search_attribute_operator_by_attribute
            cached = operator
            base_class.search_with_operator_by_name[attribute].should == cached
          end

          context 'attribute' do
            subject(:operator_attribute) do
              operator.attribute
            end

            it 'should be the attribute passed to search_attribute' do
              operator_attribute.should == attribute
            end
          end

          context 'klass' do
            subject(:klass) do
              operator.klass
            end

            it 'should be class on which search_attribute was called' do
              klass.should == base_class
            end
          end

          context 'type' do
            subject(:operator_type) do
              operator.type
            end

            it 'should be type passed to search_attribute' do
              operator_type.should == type
            end
          end
        end
      end

      context 'without :type' do
        it 'should raise Metasploit::Model::Invalid' do
          expect {
            base_class.search_attribute(attribute)
          }.to raise_error(Metasploit::Model::Invalid)
        end
      end
    end

    context 'without attribute' do
      let(:attribute) do
        ''
      end

      it 'should raise Metasploit::Model::Invalid' do
        expect {
          base_class.search_attribute attribute, :type => :string
        }.to raise_error(Metasploit::Model::Invalid)
      end
    end
  end
end