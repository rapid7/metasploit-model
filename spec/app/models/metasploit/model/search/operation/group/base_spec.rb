require 'spec_helper'

describe Metasploit::Model::Search::Operation::Group::Base do
  subject(:group) do
    described_class.new
  end

  it { should be_a Metasploit::Model::Search::Operation::Base }

  context 'validations' do
    context 'children' do
      it { should ensure_length_of(:children).is_at_least(1).with_short_message('is too short (minimum is 1 child)') }

      context '#children_valid' do
        subject(:children_valid) do
          group.send(:children_valid)
        end

        #
        # let
        #

        let(:error) do
          I18n.translate!(:'errors.messages.invalid')
        end

        let(:group) do
          described_class.new(
              children: children
          )
        end

        context 'with children' do
          #
          # lets
          #

          let(:children) do
            Array.new(2) { |i|
              double("Child #{i}")
            }
          end

          #
          # Callbacks
          #

          context 'with all valid' do
            before(:each) do
              children.each do |child|
                child.stub(valid?: true)
              end
            end

            it 'does not add error on :children' do
              group.valid?

              group.errors[:children].should_not include(error)
            end
          end

          context 'with later valid' do
            before(:each) do
              children.first.stub(valid?: false)
              children.second.stub(valid?: true)
            end

            it 'does not short-circuit and validates all children' do
              children.second.should_receive(:valid?).and_return(true)

              children_valid
            end

            it 'should add error on :children' do
              group.valid?

              group.errors[:children].should include(error)
            end
          end
        end

        context 'without children' do
          let(:children) do
            []
          end

          it 'does not add error on :children' do
            group.valid?

            group.errors[:children].should_not include(error)
          end
        end
      end
    end
  end

  context '#children' do
    subject(:children) do
      group.children
    end

    context 'default' do
      it { should == [] }
    end

    context 'with attribute' do
      let(:expected_children) do
        [
            double('child')
        ]
      end

      let(:group) do
        described_class.new(
            children: expected_children
        )
      end

      it 'is the value passed with :children to #new' do
        children.should == expected_children
      end
    end
  end
end