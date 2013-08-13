require 'spec_helper'

describe Metasploit::Model::Search do
  context 'included' do
    let(:base_class) do
      Class.new
    end

    it 'should extend Metasploit::Model::Search::Translation' do
      base_class.should_receive(:extend).with(Metasploit::Model::Search::Translation)
      # for ClassMethods from various concerns
      base_class.should_receive(:extend).with(anything).at_least(:once)

      base_class.send(:include, described_class)
    end
  end

  context 'base class' do
    subject(:base_instance) do
      base_class.new
    end

    let(:base_class) do
      Class.new
    end

    before(:each) do
      # class needs to be named or search_i18n_scope will error
      stub_const('Searched', base_class)

      base_class.send(:include, described_class)
    end

    it { should be_a Metasploit::Model::Search::Association }
    it { should be_a Metasploit::Model::Search::Attribute }

    context 'search_operator_by_name' do
      subject(:search_operator_by_name) do
        base_class.search_operator_by_name
      end

      context 'with search attribute' do
        let(:attribute) do
          :searched_attribute
        end

        before(:each) do
          base_class.search_attribute attribute, :type => :string
        end

        context 'operator' do
          subject(:operator) do
            search_operator_by_name[attribute]
          end

          context 'name' do
            subject(:name) do
              operator.name
            end

            it 'should be same as the attribute' do
              name.should == attribute
            end
          end
        end
      end

      context 'with search association' do
        let(:association) do
          :associated_things
        end

        before(:each) do
          base_class.search_association association
        end

        context 'with reflect_on_association' do
          before(:each) do
            base_class.send(:include, Metasploit::Model::Association)
          end

          context 'with association' do
            let(:associated_attribute) do
              :association_name
            end

            let(:association_class) do
              Class.new
            end

            let(:class_name) do
              'AssociatedThing'
            end

            before(:each) do
              stub_const(class_name, association_class)

              # Include after stub so search_i18n_scope can use Class#name without error
              association_class.send(:include, Metasploit::Model::Search)
              association_class.search_attribute associated_attribute, :type => :string

              base_class.association association, :class_name => class_name
            end

            context 'operator' do
              subject(:operator) do
                search_operator_by_name[expected_name]
              end

              let(:expected_name) do
                "#{association}.#{associated_attribute}".to_sym
              end

              it { should be_a Metasploit::Model::Search::Operator::Association }

              context 'association' do
                subject(:operator_association) do
                  operator.association
                end

                it 'should be the registered association' do
                  operator_association.should == association
                end
              end

              context 'attribute_operator' do
                subject(:indirect_attribute_operator) do
                  operator.attribute_operator
                end

                let(:direct_attribute_operator) do
                  association_class.search_operator_by_name.values.first
                end

                it 'should be operator from associated class' do
                  indirect_attribute_operator.should == direct_attribute_operator
                end
              end

              context 'klass' do
                subject(:klass) do
                  operator.klass
                end

                it 'should be class that called search_operator_by_name' do
                  klass.should == base_class
                end
              end
            end
          end

          context 'without association' do
            it 'should raise Metasploit::Model::Association::Error' do
              expect {
                search_operator_by_name
              }.to raise_error(Metasploit::Model::Association::Error)
            end

            context 'error' do
              let(:error) do
                begin
                  search_operator_by_name
                rescue Metasploit::Model::Association::Error => error
                  error
                end
              end

              context 'model' do
                subject(:model) do
                  error.model
                end

                it 'should be class on which search_operator_by_name was called' do
                  model.should == base_class
                end
              end

              context 'name' do
                subject(:name) do
                  error.name
                end

                it 'should be association name' do
                  name.should == association
                end
              end
            end
          end
        end

        context 'without reflect_on_association' do
          it 'should raise ArgumentError' do
            expect {
              search_operator_by_name
            }.to raise_error(
                     NameError,
                     "#{base_class} does not respond to reflect_on_association.  " \
                     "It can be added to ActiveModels by including Metasploit::Model::Association into the class."
                 )
          end
        end
      end

      context 'without search attribute' do
        context 'without search association' do
          it { should be_empty }
        end
      end
    end
  end
end