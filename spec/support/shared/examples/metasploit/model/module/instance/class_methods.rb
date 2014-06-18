shared_examples_for 'Metasploit::Model::Module::Instance::ClassMethods' do
  context '#allows?' do
    subject(:allows?) do
      singleton_class.allows?(options)
    end

    let(:options) do
      {
          attribute: attribute,
          module_type: module_type
      }
    end

    context ":attribute" do
      context 'with :actions' do
        let(:attribute) do
          :actions
        end

        context ':module_type' do
          context 'with auxiliary' do
            let(:module_type) do
              'auxiliary'
            end

            it { should be_true }
          end

          context 'with encoder' do
            let(:module_type) do
              'encoder'
            end

            it { should be_false }
          end

          context 'with exploit' do
            let(:module_type) do
              'exploit'
            end

            it { should be_false }
          end

          context 'with nop' do
            let(:module_type) do
              'nop'
            end

            it { should be_false }
          end

          context 'with payload' do
            let(:module_type) do
              'payload'
            end

            it { should be_false }
          end

          context 'with post' do
            let(:module_type) do
              'post'
            end

            it { should be_true }
          end
        end
      end

      context 'with :module_architectures' do
        let(:attribute) do
          :module_architectures
        end

        context ':module_type' do
          context 'with auxiliary' do
            let(:module_type) do
              'auxiliary'
            end

            it { should be_false }
          end

          context 'with encoder' do
            let(:module_type) do
              'encoder'
            end

            it { should be_true }
          end

          context 'with exploit' do
            let(:module_type) do
              'exploit'
            end

            it { should be_true }
          end

          context 'with nop' do
            let(:module_type) do
              'nop'
            end

            it { should be_true }
          end

          context 'with payload' do
            let(:module_type) do
              'payload'
            end

            it { should be_true }
          end

          context 'with post' do
            let(:module_type) do
              'post'
            end

            it { should be_true }
          end
        end
      end

      context 'with :module_platforms' do
        let(:attribute) do
          :module_platforms
        end

        context ':module_type' do
          context 'with auxiliary' do
            let(:module_type) do
              'auxiliary'
            end

            it { should be_false }
          end

          context 'with encoder' do
            let(:module_type) do
              'encoder'
            end

            it { should be_false }
          end

          context 'with exploit' do
            let(:module_type) do
              'exploit'
            end

            it { should be_true }
          end

          context 'with nop' do
            let(:module_type) do
              'nop'
            end

            it { should be_false }
          end

          context 'with payload' do
            let(:module_type) do
              'payload'
            end

            it { should be_true }
          end

          context 'with post' do
            let(:module_type) do
              'post'
            end

            it { should be_true }
          end
        end
      end

      context 'with :module_references' do
        let(:attribute) do
          :module_references
        end

        context ':module_type' do
          context 'with auxiliary' do
            let(:module_type) do
              'auxiliary'
            end

            it { should be_true }
          end

          context 'with encoder' do
            let(:module_type) do
              'encoder'
            end

            it { should be_false }
          end

          context 'with exploit' do
            let(:module_type) do
              'exploit'
            end

            it { should be_true }
          end

          context 'with nop' do
            let(:module_type) do
              'nop'
            end

            it { should be_false }
          end

          context 'with payload' do
            let(:module_type) do
              'payload'
            end

            it { should be_false }
          end

          context 'with post' do
            let(:module_type) do
              'post'
            end

            it { should be_true }
          end
        end
      end

      context 'with :targets' do
        let(:attribute) do
          :targets
        end

        context ':module_type' do
          context 'with auxiliary' do
            let(:module_type) do
              'auxiliary'
            end

            it { should be_false }
          end

          context 'with encoder' do
            let(:module_type) do
              'encoder'
            end

            it { should be_false }
          end

          context 'with exploit' do
            let(:module_type) do
              'exploit'
            end

            it { should be_true }
          end

          context 'with nop' do
            let(:module_type) do
              'nop'
            end

            it { should be_false }
          end

          context 'with payload' do
            let(:module_type) do
              'payload'
            end

            it { should be_false }
          end

          context 'with post' do
            let(:module_type) do
              'post'
            end

            it { should be_false }
          end
        end
      end
    end

    context '#dynamic_length_validation_options' do
      let(:options) do
        # don't care about the options since #dynamic_length_validation_options is being stubbed
        {}
      end

      before(:each) do
        singleton_class.stub(dynamic_length_validation_options: dynamic_length_validation_options)
      end

      context 'with :is' do
        let(:dynamic_length_validation_options) do
          {
              is: is
          }
        end

        context '> 0' do
          let(:is) do
            1
          end

          it { should be_true }
        end

        context '<= 0' do
          let(:is) do
            0
          end

          it { should be_false }
        end
      end

      context 'without :is' do
        context 'with :maximum' do
          let(:dynamic_length_validation_options) do
            {
                maximum: maximum
            }
          end

          context '> 0' do
            let(:maximum) do
              1
            end

            it { should be_true }
          end

          context '<= 0' do
            let(:maximum) do
              0
            end

            it { should be_false }
          end
        end

        context 'without :maximum' do
          let(:dynamic_length_validation_options) do
            {}
          end

          it { should be_true }
        end
      end
    end
  end

  context '#dynamic_length_validation_options' do
    subject(:dynamic_length_validation_options) do
      singleton_class.dynamic_length_validation_options(options)
    end

    let(:attribute) do
      attributes.sample
    end

    let(:attributes) do
      [
          :actions,
          :module_architectures,
          :module_platforms,
          :module_references,
          :targets
      ]
    end

    let(:module_type) do
      FactoryGirl.generate :metasploit_model_module_type
    end

    let(:options) do
      {}
    end

    context 'with :attribute' do
      let(:options) do
        super().merge(
            attribute: attribute
        )
      end

      context 'with :module_type' do
        let(:options) do
          super().merge(
              module_type: module_type
          )
        end

        context 'with valid :attribute' do
          context 'with valid :module_type' do
            it 'should return Hash from DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE' do
              dynamic_length_validation_options.should be described_class::DYNAMIC_LENGTH_VALIDATION_OPTIONS_BY_MODULE_TYPE_BY_ATTRIBUTE[attribute][module_type]
            end
          end

          context 'without valid :module_type' do
            let(:module_type) do
              'invalid_module_type'
            end

            specify {
              expect {
                dynamic_length_validation_options
              }.to raise_error(KeyError)
            }
          end
        end

        context 'without valid attribute' do
          let(:attribute) do
            :invalid_attribute
          end

          specify {
            expect {
              dynamic_length_validation_options
            }.to raise_error(KeyError)
          }
        end
      end

      context 'without :module_type' do
        specify {
          expect {
            dynamic_length_validation_options
          }.to raise_error(KeyError)
        }
      end
    end

    context 'without :attribute' do
      context 'with :module_type' do
        let(:options) do
          super().merge(
              module_type: module_type
          )
        end

        specify {
          expect {
            dynamic_length_validation_options
          }.to raise_error(KeyError)
        }
      end

      context 'without :module_type' do
        specify {
          expect {
            dynamic_length_validation_options
          }.to raise_error(KeyError)
        }
      end
    end
  end

  context '#stanced?' do
    subject(:stanced?) do
      singleton_class.stanced?(module_type)
    end

    context '#module_type' do
      context "with 'auxiliary'" do
        let(:module_type) do
          'auxiliary'
        end

        it { should be_true }
      end

      context "with 'encoder'" do
        let(:module_type) do
          'encoder'
        end

        it { should be_false }
      end

      context "with 'exploit'" do
        let(:module_type) do
          'exploit'
        end

        it { should be_true }
      end

      context "with 'nop'" do
        let(:module_type) do
          'nop'
        end

        it { should be_false }
      end

      context "with 'payload'" do
        let(:module_type) do
          'payload'
        end

        it { should be_false }
      end

      context "with 'post'" do
        let(:module_type) do
          'post'
        end

        it { should be_false }
      end

      context "with nil" do
        let(:module_type) do
          nil
        end

        it { should be_false }
      end
    end
  end
end