shared_examples_for 'Metasploit::Model::Configuration::Parent#child' do |name, options={}|
  options.assert_valid_keys(:class)

  klass = options.fetch(:class)
  class_attribute_name = "#{name}_class"

  context "##{name}" do
    subject(:child) do
      configuration.send(name)
    end

    context "with default ##{class_attribute_name}" do
      it { should be_a klass }
    end

    context "without default ##{class_attribute_name}" do
      #
      # lets
      #

      let(:non_default_class) do
        Class.new do
          attr_accessor :configuration
        end
      end

      #
      # Callbacks
      #

      before(:each) do
        configuration.send("#{class_attribute_name}=", non_default_class)
      end

      it "is instance of ##{class_attribute_name}" do
        expect(child).to be_a non_default_class
      end
    end

    context '#configuration' do
      subject(:child_configuration) do
        child.configuration
      end

      it 'is this configuration' do
        expect(child_configuration).to eq(configuration)
      end
    end
  end

  context "#{class_attribute_name}" do
    subject(:child_class) do
      configuration.send(class_attribute_name)
    end

    context 'default' do
      it { should be klass }
    end
  end
end