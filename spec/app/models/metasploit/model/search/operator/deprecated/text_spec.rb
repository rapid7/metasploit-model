require 'spec_helper'

describe Metasploit::Model::Search::Operator::Deprecated::Text do
  subject(:operator) do
    described_class.new(
        :klass => klass
    )
  end

  let(:klass) do
    Class.new
  end

  context 'CONSTANTS' do
    context 'OPERATOR_NAMES' do
      subject(:operator_names) do
        described_class::OPERATOR_NAMES
      end

      it { should include 'description' }
      it { should include 'name' }
      it { should include 'actions.name' }

      it 'should include platform instead of platforms.fully_qualified_name and targets.name' do
        operator_names.should include('platform')
        operator_names.should_not include('platforms.fully_qualified_name')
        operator_names.should_not include('targets.name')
      end

      it 'should include ref instead of authors.name, references.designation and references.url to handle deprecated reference syntax' do
        operator_names.should include('ref')
        operator_names.should_not include('authors.name')
        operator_names.should_not include('references.designation')
        operator_names.should_not include('references.url')
      end
    end
  end

  context '#children' do
    include_context 'Metasploit::Model::Search::Operator::Group::Union#children'

    let(:action_name_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :name,
          :klass => action_class,
          :type => :string
      )
    end

    let(:action_class) do
      Class.new
    end

    let(:actions_name_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :actions,
          :attribute_operator => action_name_operator,
          :klass => klass
      )
    end

    let(:architecture_class) do
      Class.new
    end

    let(:architecture_abbreviation_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :abbreviation,
          :klass => architecture_class,
          :type => :string
      )
    end

    let(:architectures_abbreviation_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :architectures,
          :attribute_operator => architecture_abbreviation_operator,
          :klass => klass
      )
    end

    let(:authority_class) do
      Class.new
    end

    let(:authority_abbreviation_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :abbreviation,
          :klass => authority_class,
          :type => :string
      )
    end

    let(:authorities_abbreviation_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :authorities,
          :attribute_operator => authority_abbreviation_operator,
          :klass => klass
      )
    end

    let(:description_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :description,
          :klass => klass,
          :type => :string
      )
    end

    let(:formatted_value) do
      'value'
    end

    let(:name_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :name,
          :klass => klass,
          :type => :string
      )
    end

    let(:platform_class) do
      Class.new
    end

    let(:platform_operator) do
      Metasploit::Model::Search::Operator::Deprecated::Platform.new(
          :klass => klass,
          :name => :platform
      )
    end

    let(:platform_fully_qualified_name_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :fully_qualified_name,
          :klass => platform_class,
          :type => :string
      )
    end

    let(:platforms_fully_qualified_name_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :platforms,
          :attribute_operator => platform_fully_qualified_name_operator,
          :klass => klass
      )
    end

    let(:ref_operator) do
      Metasploit::Model::Search::Operator::Deprecated::Ref.new(
          :klass => klass
      )
    end

    let(:reference_class) do
      Class.new
    end

    let(:reference_designation_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :designation,
          :klass => reference_class,
          :type => :string
      )
    end

    let(:references_designation_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :references,
          :attribute_operator => reference_designation_operator,
          :klass => klass
      )
    end

    let(:reference_url_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :url,
          :klass => reference_class,
          :type => :string
      )
    end

    let(:references_url_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :references,
          :attribute_operator => reference_url_operator,
          :klass => klass
      )
    end

    let(:target_class) do
      Class.new
    end

    let(:target_name_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :name,
          :klass => target_class,
          :type => :string
      )
    end

    let(:targets_name_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :targets,
          :attribute_operator => target_name_operator,
          :klass => klass
      )
    end

    before(:each) do
      operator.stub(:operator).with('description').and_return(description_operator)
      operator.stub(:operator).with('name').and_return(name_operator)
      operator.stub(:operator).with('actions.name').and_return(actions_name_operator)
      operator.stub(:operator).with('architectures.abbreviation').and_return(architectures_abbreviation_operator)
      operator.stub(:operator).with('platform').and_return(platform_operator)
      operator.stub(:operator).with('ref').and_return(ref_operator)

      platform_operator.stub(:operator).with(
          'platforms.fully_qualified_name'
      ).and_return(
          platforms_fully_qualified_name_operator
      )
      platform_operator.stub(:operator).with('targets.name').and_return(targets_name_operator)

      ref_operator.stub(:operator).with('authorities.abbreviation').and_return(authorities_abbreviation_operator)
      ref_operator.stub(:operator).with('references.designation').and_return(references_designation_operator)
      ref_operator.stub(:operator).with('references.url').and_return(references_url_operator)
    end

    context 'description' do
      subject(:operation) do
        child('description')
      end

      it 'should use formatted value for value' do
        operation.value.should == formatted_value
      end
    end

    context 'name' do
      subject(:operation) do
        child('name')
      end

      it 'should use formatted value for value' do
        operation.value.should == formatted_value
      end
    end

    context 'actions.name' do
      subject(:operation) do
        child('actions.name')
      end

      it 'should use formatted value for value' do
        operation.value.should == formatted_value
      end
    end

    context 'architectures.abbreviation' do
      subject(:operation) do
        child('architectures.abbreviation')
      end

      it 'should use formatted value for value' do
        operation.value.should == formatted_value
      end
    end

    context 'platform' do
      subject(:child_operation) do
        child('platform')
      end

      context 'children' do
        subject(:grandchildren) do
          child_operation.children
        end

        def grandchild(formatted_operator)
          grandchildren.find { |operation|
            operation.operator.name == formatted_operator.to_sym
          }
        end

        context 'platforms.fully_qualified_name' do
          subject(:grandchild_operation) do
            grandchild('platforms.fully_qualified_name')
          end

          it 'should use formatted value for value' do
            grandchild_operation.value.should == formatted_value
          end
        end

        context 'targets.name' do
          subject(:grandchild_operation) do
            grandchild('targets.name')
          end

          it 'should use formatted value for value' do
            grandchild_operation.value.should == formatted_value
          end
        end
      end
    end

    context 'ref' do
      subject(:child_operation) do
        child('ref')
      end

      context 'children' do
        subject(:grandchildren) do
          child_operation.children
        end

        def grandchild(formatted_operator)
          grandchildren.find { |operation|
            operation.operator.name == formatted_operator.to_sym
          }
        end

        context 'authorities.abbreviation' do
          subject(:grandchild_operation) do
            grandchild('authorities.abbreviation')
          end

          it 'should use formatted value for value' do
            grandchild_operation.value.should == formatted_value
          end
        end

        context 'references.designation' do
          subject(:grandchild_operation) do
            grandchild('references.designation')
          end

          it 'should use formatted value for value' do
            grandchild_operation.value.should == formatted_value
          end
        end

        context 'references.url' do
          subject(:grandchild_operation) do
            grandchild('references.url')
          end

          it 'should use formatted value for value' do
            grandchild_operation.value.should == formatted_value
          end
        end
      end
    end
  end
end