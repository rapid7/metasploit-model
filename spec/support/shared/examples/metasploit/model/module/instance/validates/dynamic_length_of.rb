shared_examples_for 'Metasploit::Model::Module::Instance validates dynamic length of' do |attribute, options={}|
  options.assert_valid_keys(:options_by_extreme_by_module_type, :factory)
  options_by_extreme_by_module_type = options.fetch(:options_by_extreme_by_module_type)
  attribute_factory = options.fetch(:factory)

  context attribute do
    context 'errors' do
      subject(:attribute_errors) do
        module_instance.errors[attribute]
      end

      let(attribute) do
        FactoryGirl.build_list(
            attribute_factory,
            attribute_count,
            module_instance: module_instance
        )
      end

      let(:attribute_count) do
        Random.rand(attribute_count_range)
      end

      let(:error) do
        # need to use human_attribute_name to emulate error translation process from ActiveModel::Errors.
        I18n.translate!(
            error_key,
            count: extreme_value,
            attribute: human_attribute_name
        )
      end

      let(:error_key) do
        "metasploit.model.errors.models.metasploit/model/module/instance.attributes.#{attribute}.#{error_type}"
      end

      let(:human_attribute_name) do
        module_instance.class.human_attribute_name(attribute)
      end

      before(:each) do
        module_instance.send("#{attribute}=", send(attribute))
        module_instance.module_class.module_type = module_type
        # populate attribute_errors
        module_instance.valid?
      end

      context '#module_type' do
        Metasploit::Model::Module::Type::ALL.each do |module_type|
          options_by_extreme = options_by_extreme_by_module_type.fetch(module_type)

          options_by_extreme.assert_valid_keys(:maximum, :minimum)

          maximum_options = options_by_extreme.fetch(:maximum)
          maximum_options.assert_valid_keys(:extreme, :error_type)
          maximum = maximum_options.fetch(:extreme)

          minimum_options = options_by_extreme.fetch(:minimum)
          minimum_options.assert_valid_keys(:extreme, :error_type)
          minimum = minimum_options.fetch(:extreme)

          context "with #{module_type.inspect}" do
            # has to be captured in a let so before(:each) in outer context can use it
            let(:module_type) do
              module_type
            end

            if minimum > 0
              # fetch error_type here because it is only needs to be given if minimum > 0.
              minimum_error_type = minimum_options.fetch(:error_type)

              context "below minimum (#{minimum})" do
                let(:attribute_count_range) do
                  0 ... minimum
                end

                let(:error_type) do
                  minimum_error_type
                end

                let(:extreme_value) do
                  minimum
                end

                it { should include(error) }
              end
            end

            clamped_minimum = 2 * minimum + 1
            # maximum may be infinity, so need to clamp it to a more realistic value that can be built from factories
            clamped_maximum = [maximum, clamped_minimum].min

            if maximum > minimum
              context "in range (#{minimum} .. #{maximum})" do
                let(:attribute_count_range) do
                  minimum .. clamped_maximum
                end

                it { should be_empty }
              end
            end

            if maximum < Float::INFINITY
              # fetch error_type here because it only needs to be given if maximum is not ∞
              maximum_error_type = maximum_options.fetch(:error_type)

              context "above maximum (#{maximum})" do
                above_maximum = maximum + 1

                let(:attribute_count_range) do
                  # 2 to double the range
                  above_maximum .. (2 * above_maximum)
                end

                let(:error_type) do
                  maximum_error_type
                end

                let(:extreme_value) do
                  maximum
                end

                it { should include(error) }
              end
            end
          end
        end
      end
    end
  end
end