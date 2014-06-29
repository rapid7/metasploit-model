require 'spec_helper'

describe Metasploit::Model::Search::Operator::Deprecated::Ref do
  subject(:operator) do
    described_class.new(
        :klass => klass
    )
  end

  let(:klass) do
    Class.new
  end

  context '#children' do
    include_context 'Metasploit::Model::Search::Operator::Group::Union#children'

    let(:abbreviation_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :abbreviation,
          :klass => authority_class,
          :type => :string
      )
    end

    let(:authority_class) do
      Class.new
    end

    let(:authorities_abbreviation_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :authorities,
          :attribute_operator => abbreviation_operator,
          :klass => klass
      )
    end

    let(:designation_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :designation,
          :klass => reference_class,
          :type => :string
      )
    end

    let(:reference_class) do
      Class.new
    end

    let(:references_designation_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :references,
          :attribute_operator => designation_operator,
          :klass => klass
      )
    end

    let(:references_url_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :references,
          :attribute_operator => url_operator,
          :klass => klass
      )
    end

    let(:url_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :url,
          :klass => reference_class,
          :type => :string
      )
    end

    before(:each) do
      operator.stub(:operator).with('authorities.abbreviation').and_return(authorities_abbreviation_operator)
      operator.stub(:operator).with('references.designation').and_return(references_designation_operator)
      operator.stub(:operator).with('references.url').and_return(references_url_operator)
    end

    context "with '-'" do
      let(:formatted_value) do
        "#{head}-#{tail}"
      end

      context "with 'URL'" do
        let(:head) do
          'URL'
        end

        context 'with blank url' do
          let(:tail) do
            ''
          end

          it { should be_empty }
        end

        context 'without blank url' do
          let(:tail) do
            FactoryGirl.generate :metasploit_model_reference_url
          end

          context 'authorities.abbreviation' do
            subject(:operation) do
              child('authorities.abbreviation')
            end

            it 'should not be in children' do
              operation.should be_nil
            end
          end

          context 'references.designation' do
            subject(:operation) do
              child('references.designation')
            end

            it 'should not be in children' do
              operation.should be_nil
            end
          end

          context 'references.url' do
            subject(:operation) do
              child('references.url')
            end

            it "should use portion of formatted value after 'URL-' for value" do
              operation.value.should == tail
            end
          end
        end
      end

      context "without 'URL'" do
        let(:head) do
          FactoryGirl.generate :metasploit_model_authority_abbreviation
        end

        let(:tail) do
          FactoryGirl.generate :metasploit_model_reference_designation
        end

        context 'with blank head' do
          let(:head) do
            ''
          end

          context 'authorities.abbreviation' do
            subject(:operation) do
              child('authorities.abbreviation')
            end

            it 'should not be in children' do
              operation.should be_nil
            end
          end

          context 'references.designation' do
            subject(:operation) do
              child('references.designation')
            end

            it "should use portion of formatted value after '-' for value" do
              operation.value.should == tail
            end
          end

          context 'references.url' do
            subject(:operation) do
              child('references.url')
            end

            it 'should not be in children' do
              operation.should be_nil
            end
          end
        end

        context 'without blank head' do
          context 'authorities.abbreviation' do
            subject(:operation) do
              child('authorities.abbreviation')
            end

            it "should use portion of formatted value before '-' as value" do
              operation.value.should == head
            end
          end

          context 'references.designation' do
            subject(:operation) do
              child('references.designation')
            end

            it "should use portion of formatted value after '-' as value" do
              operation.value.should == tail
            end
          end

          context 'references.url' do
            subject(:operation) do
              child('references.url')
            end

            it 'should not be in children' do
              operation.should be_nil
            end
          end
        end

        context 'with blank tail' do
          let(:tail) do
            ''
          end

          context 'authorities.abbreviation' do
            subject(:operation) do
              child('authorities.abbreviation')
            end

            it "should use portion of formatted value before '-' for value" do
              operation.value.should == head
            end
          end

          context 'references.designation' do
            subject(:operation) do
              child('references.designation')
            end

            it 'should not be in children' do
              operation.should be_nil
            end
          end

          context 'references.url' do
            subject(:operation) do
              child('references.url')
            end

            it 'should not be in children' do
              operation.should be_nil
            end
          end
        end

        context 'without blank tail' do
          context 'authorities.abbreviation' do
            subject(:operation) do
              child('authorities.abbreviation')
            end

            it "should use portion of format value before '-' for value" do
              operation.value.should == head
            end
          end

          context 'references.designation' do
            subject(:operation) do
              child('references.designation')
            end

            it "should use portion of format value after '-' for value" do
              operation.value.should == tail
            end
          end

          context 'references.url' do
            subject(:operation) do
              child('references.url')
            end

            it 'should not be in children' do
              operation.should be_nil
            end
          end
        end
      end
    end

    context "without '-'" do
      context 'with blank' do
        let(:formatted_value) do
          ''
        end

        it { should be_empty }
      end

      context 'without blank' do
        let(:formatted_value) do
          'ref_value'
        end

        context 'authorities.abbreviation' do
          subject(:operation) do
            child('authorities.abbreviation')
          end

          it 'should use formatted value for value' do
            operation.value.should == formatted_value
          end
        end

        context 'references.designation' do
          subject(:operation) do
            child('references.designation')
          end

          it 'should use formatted value for value' do
            operation.value.should == formatted_value
          end
        end

        context 'references.url' do
          subject(:operation) do
            child('references.url')
          end

          it 'should use formatted value for value' do
            operation.value.should == formatted_value
          end
        end
      end
    end
  end
end