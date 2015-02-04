Metasploit::Model::Spec.shared_examples_for 'Module::Rank' do
  subject(:module_rank) do
    # need non-factory subject since ranks are only seeded and so a sequence.
    # The sequence elements can't be used as they are frozen.
    module_rank_class.new
  end

  context 'CONSTANTS' do
    context 'NAME_BY_NUMBER' do
      subject(:name_by_numnber) do
        described_class::NAME_BY_NUMBER
      end

      its([0]) { should == 'Manual' }
      its([100]) { should == 'Low' }
      its([200]) { should == 'Average' }
      its([300]) { should == 'Normal' }
      its([400]) { should == 'Good' }
      its([500]) { should == 'Great' }
      its([600]) { should == 'Excellent' }
    end

    context 'NAME_REGEXP' do
      subject(:name_regexp) do
        described_class::NAME_REGEXP
      end

      it 'should not match a #name starting with a lowercase letter' do
        name_regexp.should_not match('good')
      end

      it 'should match a #name starting with a capital letter' do
        name_regexp.should match('Good')
      end

      it 'should not match a #name with a space' do
        name_regexp.should_not match('Super Effective')
      end
    end

    context 'NUMBER_BY_NAME' do
      subject(:number_by_name) do
        described_class::NUMBER_BY_NAME
      end

      its(['Manual']) { should == 0 }
      its(['Low']) { should == 100 }
      its(['Average']) { should == 200 }
      its(['Normal']) { should == 300 }
      its(['Good']) { should == 400 }
      its(['Great']) { should == 500 }
      its(['Excellent']) { should == 600 }
    end
  end

  context 'search' do
    context 'attributes' do
      it_should_behave_like 'search_attribute', :name, :type => :string
      it_should_behave_like 'search_attribute', :number, :type => :integer
    end
  end

  context 'validations' do
    context 'name' do
      it { should ensure_inclusion_of(:name).in_array(described_class::NUMBER_BY_NAME.keys) }

      context 'format' do
        it 'should not allow #name starting with a lowercase letter' do
          module_rank.should_not allow_value('good').for(:name)
        end

        it 'should allow #name starting with a capital letter' do
          module_rank.should allow_value('Good').for(:name)
        end

        it 'should not allow #name with a space' do
          module_rank.should_not allow_value('Super Effective').for(:name)
        end
      end
    end

    context 'number' do
      it { should ensure_inclusion_of(:number).in_array(described_class::NUMBER_BY_NAME.values) }
      it { should validate_numericality_of(:number).only_integer }
    end
  end
end