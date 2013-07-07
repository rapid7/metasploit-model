require 'spec_helper'

describe Metasploit::Model::Derivation do
  let(:base_class) do
    # capture for class_eval scope
    described_class = self.described_class

    Class.new do
      extend ActiveModel::Callbacks
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks

      include described_class
    end
  end

  context 'included' do
    let(:base_class) do
      Class.new do
        extend ActiveModel::Callbacks
        include ActiveModel::Validations
        include ActiveModel::Validations::Callbacks
      end
    end

    it 'should register #derive as a before validation callback' do
      base_class.should_receive(:before_validation).with(:derive)

      # capture for class_eval scope
      described_class = self.described_class

      base_class.class_eval do
        include described_class
      end
    end
  end

  context '#derive' do
    subject(:derive) do
      base_instance.send(:derive)
    end

    let(:attributes) do
      [
          :derivation,
          :formula
      ]
    end

    let(:base_instance) do
      base_class.new
    end

    let(:derivation) do
      'derivation'
    end

    let(:formula) do
      nil
    end

    before(:each) do
      # capture for class_eval scope
      attributes = self.attributes

      base_class.class_eval do
        #
        # Attributes
        #

        # @!attribute [rw] derivation
        #   @return [String]
        attr_accessor :derivation

        # @!attribute [rw] formula
        #   @return [String]
        attr_accessor :formula

        #
        # Derivations
        #

        derives :derivation
        derives :formula

        #
        # Methods
        #

        # Derives #derivation.
        #
        # @return [String]
        def derived_derivation
          'derived_derivation'
        end

        # Derives #formula.
        #
        # @return [String]
        def derived_formula
          'derived_formula'
        end
      end

      base_instance.derivation = derivation
      base_instance.formula = formula
    end

    it 'should test value with nil?' do
      derivation.should_receive(:nil?).and_return(false)

      derive
    end

    context 'with nil value' do
      it 'should set attribute to derived_<attribute>' do
        derive

        base_instance.formula.should == base_instance.derived_formula
      end
    end

    context 'without nil value' do
      it 'should not set attribute to derived_<attribute>' do
        derive

        base_instance.derivation.should_not == base_instance.derived_derivation
      end
    end
  end

  context 'derives' do
    let(:attribute) do
      :derivative
    end

    context 'with :validate' do
      subject(:derives) do
        base_class.derives attribute, :validate => validate
      end

      context 'false' do
        let(:validate) do
          false
        end

        it 'should record :validate in validate_by_derived_attribute' do
          derives

          base_class.validate_by_derived_attribute[attribute].should == validate
        end

        it 'should not add derivation validation on attribute' do
          base_class.should_not_receive(:validates).with(
              attribute,
              hash_including(
                  :derivation => true
              )
          )

          derives
        end
      end

      context 'true' do
        let(:validate) do
          true
        end

        it 'should record :validate in validate_by_derived_attribute' do
          derives

          base_class.validate_by_derived_attribute[attribute].should == validate
        end

        it 'should not add derivation validation on attribute' do
          base_class.should_receive(:validates).with(
              attribute,
              hash_including(
                  :derivation => true
              )
          )

          derives
        end
      end
    end

    context 'without :validate' do
      subject(:derives) do
        base_class.derives attribute
      end

      it 'should default to false' do
        derives

        base_class.validate_by_derived_attribute[attribute].should be_false
      end

      it 'should not call validates' do
        base_class.should_not_receive(:validates)

        derives
      end
    end
  end

  context 'validate_by_derived_attribute' do
    subject(:validate_by_derived_attribute) do
      base_class.validate_by_derived_attribute
    end

    it 'should default to {}' do
      validate_by_derived_attribute.should == {}
    end
  end
end