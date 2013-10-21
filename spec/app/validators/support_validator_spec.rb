require 'spec_helper'

describe SupportValidator do
  subject(:support_validator) do
    described_class.new(attributes: attributes)
  end

  let(:attribute) do
    :items
  end

  let(:attributes) do
    [
        attribute
    ]
  end

  context 'CONSTANTS' do
    context 'MINIMUM_LENGTH' do
      subject(:minimum_length) do
        described_class::MINIMUM_LENGTH
      end

      it { should == 1 }
    end
  end

  context '#validate_each' do
    subject(:attribute_errors) do
      record.errors[attribute]
    end

    let(:human_attribute_name) do
      record_class.human_attribute_name(attribute)
    end

    let(:record) do
      record_class.new(items: items)
    end

    let(:record_class) do
      attribute = self.attribute

      Class.new(Metasploit::Model::Base) do
        def self.model_name
          @model_name ||= ActiveModel::Name.new(self, nil, 'RecordClass')
        end

        #
        # Associations
        #

        # @!attribute [rw] items
        #  Items this record owns.
        #
        #  @return [Array]
        def items
          @items ||= []
        end
        attr_writer :items

        #
        # Validations
        #

        validates :items,
                  support: true
      end
    end

    let(:validate_each) do
      support_validator.validate_each(record, attribute, value)
    end

    let(:value) do
      items
    end

    before(:each) do
      record.stub(:supports?).with(attribute).and_return(supports)
      validate_each
    end

    context 'with supports?(attribute)' do
      let(:supports) do
        true
      end

      let(:supported_error) do
        I18n.translate!('metasploit.model.errors.messages.supported', attribute: human_attribute_name)
      end

      context 'with items' do
        let(:items) do
          [
              double('Item')
          ]
        end

        it { should_not include(supported_error) }
      end

      context 'without items' do
        let(:items) do
          []
        end

        it { should include(supported_error) }
      end
    end

    context 'without supports?(attribute)' do
      let(:supports) do
        false
      end

      let(:unsupported_error) do
        I18n.translate!('metasploit.model.errors.messages.unsupported', attribute: human_attribute_name)
      end

      context 'with items' do
        let(:items) do
          [
              double('Item')
          ]
        end

        it { should include(unsupported_error) }
      end

      context 'without items' do
        let(:items) do
          []
        end

        it { should_not include(unsupported_error) }
      end
    end
  end
end