require 'spec_helper'

describe Metasploit::Model::Derivation::FullName do
  subject(:base_instance) do
    base_class.new
  end

  let(:base_class) do
    # capture for Class.new scope
    described_class = self.described_class

    Class.new do
      include described_class

      #
      # Attributes
      #

      # @!attribute [rw] module_type
      #   The type of module.
      #
      #   @return [String]
      attr_accessor :module_type

      # @!attribute [rw] reference_name
      #   The name of the module scoped to the {#module_type}
      #
      #   @return [String]
      attr_accessor :reference_name
    end
  end

  context '#derived_full_name' do
    subject(:derived_full_name) do
      base_instance.derived_full_name
    end

    let(:module_type) do
      nil
    end

    let(:reference_name) do
      nil
    end

    before(:each) do
      base_instance.module_type = module_type
      base_instance.reference_name = reference_name
    end

    context 'with module_type' do
      let(:module_type) do
        FactoryGirl.generate :metasploit_model_module_ancestor_module_type
      end

      context 'with reference_name' do
        let(:reference_name) do
          FactoryGirl.generate :metasploit_model_module_ancestor_reference_name
        end

        it 'should be <module_type>/<reference_name>' do
          derived_full_name.should == "#{module_type}/#{reference_name}"
        end
      end

      context 'without reference_name' do
        it { should be_nil }
      end
    end

    context 'without module_type' do
      it { should be_nil }
    end
  end
end