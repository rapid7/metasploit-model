require 'spec_helper'

describe Metasploit::Model::Search::Operator::Deprecated::Author do
  subject(:operator) do
    described_class.new(
        :klass => klass
    )
  end

  let(:klass) do
    Class.new
  end

  it { should be_a Metasploit::Model::Search::Operator::Delegation }

  context '#children' do
    include_context 'Metasploit::Model::Search::Operator::Group::Union#children'

    let(:author_class) do
      Class.new
    end

    let(:authors_name_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :authors,
          :attribute_operator => name_operator,
          :klass => klass
      )
    end

    let(:domain_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :domain,
          :klass => email_address_class,
          :type => :string
      )
    end

    let(:email_address_class) do
      Class.new
    end

    let(:email_addresses_domain_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :email_addresses,
          :attribute_operator => domain_operator,
          :klass => klass
      )
    end

    let(:email_addresses_local_operator) do
      Metasploit::Model::Search::Operator::Association.new(
          :association => :email_addresses,
          :attribute_operator => local_operator,
          :klass => klass
      )
    end

    let(:local_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :local,
          :klass => klass,
          :type => :string
      )
    end

    let(:name_operator) do
      Metasploit::Model::Search::Operator::Attribute.new(
          :attribute => :name,
          :klass => :author_class,
          :type => :string
      )
    end

    before(:each) do
      operator.stub(:operator).with('authors.name').and_return(authors_name_operator)
      operator.stub(:operator).with('email_addresses.domain').and_return(email_addresses_domain_operator)
      operator.stub(:operator).with('email_addresses.local').and_return(email_addresses_local_operator)
    end

    context "with '@'" do
      let(:formatted_value) do
        "#{local}@#{domain}"
      end

      let(:local) do
        'user'
      end

      let(:domain) do
        'example.com'
      end

      context 'authors.name' do
        subject(:operation) do
          child('authors.name')
        end

        it 'should use entire formatted value' do
          operation.value.should == formatted_value
        end
      end

      context 'email_addresses.domain' do
        subject(:operation) do
          child('email_addresses.domain')
        end

        it "should use portion of formatted value after '@'" do
          operation.value.should == domain
        end
      end

      context 'email_addresses.local' do
        subject(:operation) do
          child('email_addresses.local')
        end

        it "should use portion of formated value before '@'" do
          operation.value.should == local
        end
      end
    end

    context "without '@'" do
      let(:formatted_value) do
        'local_or_handle'
      end

      context 'authors.name' do
        subject(:operation) do
          child('authors.name')
        end

        it 'should use entire formatted value' do
          operation.value.should == formatted_value
        end
      end

      context 'email_addresses.domain' do
        subject(:operation) do
          child('email_addresses.domain')
        end

        it 'should use entire formatted value' do
          operation.value.should == formatted_value
        end
      end

      context 'email_addresses.local' do
        subject(:operation) do
          child('email_addresses.local')
        end

        it 'should use entire formatted value' do
          operation.value.should == formatted_value
        end
      end
    end
  end
end