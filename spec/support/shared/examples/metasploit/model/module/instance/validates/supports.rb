shared_examples_for 'Metasploit::Model::Module::Instance validates supports' do |attribute, options={}|
  options.assert_valid_keys(:factory)
  attribute_factory = options.fetch(:factory)

  context attribute do
    subject(:attribute_errors) do
      module_instance.errors[attribute]
    end

    let(:error) do
      # need to use human_attribute_name to emulate error translation process from ActiveModel::Errors.
      I18n.translate!(error_key, attribute: human_attribute_name)
    end

    let(:error_key) do
      "metasploit.model.errors.messages.#{error_type}"
    end

    let(:human_attribute_name) do
      module_instance.class.human_attribute_name(attribute)
    end

    let(:module_types) do
      support_by_module_type = Metasploit::Model::Module::Instance::SUPPORT_BY_MODULE_TYPE_BY_ATTRIBUTE.fetch(attribute)

      support_by_module_type.each_with_object([]) { |(module_type, support), module_types|
        if support == supports_attribute
          module_types << module_type
        end
      }
    end

    before(:each) do
      module_instance.send("#{attribute}=", send(attribute))
    end

    context "supports?(:#{attribute})" do
      before(:each) do
        module_instance.valid?
      end

      context 'with false' do
        let(:error_count) do
          2
        end

        let(:error_type) do
          :unsupported
        end

        let(:supports_attribute) do
          false
        end

        context "with #{attribute}" do
          let(attribute) do
            FactoryGirl.build_list(
                attribute_factory,
                1,
                module_instance: module_instance
            )
          end

          it { should include(error) }
        end

        context "without #{attribute}" do
          let(attribute) do
            []
          end

          it { should_not include(error) }
        end
      end

      context 'with true' do
        let(:error_count) do
          1
        end

        let(:error_type) do
          :supported
        end

        let(:supports_attribute) do
          true
        end

        context "with #{attribute}" do
          let(attribute) do
            FactoryGirl.build_list(
                attribute_factory,
                1,
                module_instance: module_instance
            )
          end

          it { should_not include(error) }
        end

        context "without #{attribute}" do
          let(attribute) do
            []
          end

          it { should include(error) }
        end
      end
    end
  end
end