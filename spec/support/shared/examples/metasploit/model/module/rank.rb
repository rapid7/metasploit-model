shared_examples_for 'Metasploit::Model::Module::Rank' do
  context 'CONSTANTS' do
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

  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:number) }
  end

  context 'search' do
    context 'search_i18n_scope' do
      subject(:search_i18n_scope) do
        described_class.search_i18n_scope
      end

      it { should == 'metasploit.model.module.rank' }
    end

    context 'attributes' do
      let(:base_class) do
        rank_class
      end

      it_should_behave_like 'search_attribute', :name, :type => :string
      it_should_behave_like 'search_attribute', :number, :type => :integer
    end
  end

  context 'validations' do
    context 'name' do
      it { should ensure_inclusion_of(:name).in_array(described_class::NUMBER_BY_NAME.keys) }

      context 'format' do
        it 'should not allow #name starting with a lowercase letter' do
          rank.should_not allow_value('good').for(:name)
        end

        it 'should allow #name starting with a capital letter' do
          rank.should allow_value('Good').for(:name)
        end

        it 'should not allow #name with a space' do
          rank.should_not allow_value('Super Effective').for(:name)
        end
      end
    end

    context 'number' do
      it { should ensure_inclusion_of(:number).in_array(described_class::NUMBER_BY_NAME.values) }
      it { should validate_numericality_of(:number).only_integer }
    end
  end
end