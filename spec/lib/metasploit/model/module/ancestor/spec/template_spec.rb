require 'spec_helper'

describe Metasploit::Model::Module::Ancestor::Spec::Template do
  subject(:template) do
    described_class.new(
        module_ancestor: module_ancestor
    )
  end

  let(:module_ancestor) do
    FactoryGirl.build(:dummy_module_ancestor)
  end

  context 'CONSTANTS' do
    context 'DEFAULT_SEARCH_PATHNAMES' do
      subject(:default_search_pathnames) do
        described_class::DEFAULT_SEARCH_PATHNAMES
      end

      it "includes 'module/ancestors'" do
        expect(default_search_pathnames).to include(Pathname.new('module/ancestors'))
      end
    end

    context 'DEFAULT_SOURCE_RELATIVE_NAME' do
      subject(:default_source_relative_name) do
        described_class::DEFAULT_SOURCE_RELATIVE_NAME
      end

      it { should == 'base' }
    end
  end

  context 'validations' do
    it { should validate_presence_of :module_ancestor }
  end

  context '#destination_pathname' do
    subject(:destination_pathname) do
      template.destination_pathname
    end

    context 'with #module_ancestor' do
      it 'defaults to module_ancestor.real_pathname' do
        expect(destination_pathname).to eq(module_ancestor.real_pathname)
      end
    end

    context 'without #module_ancestor' do
      let(:module_ancestor) do
        nil
      end

      it { should be_nil }
    end
  end

  context '#locals' do
    subject(:locals) do
      template.locals
    end

    it { should be_a Hash }

    context '[:metasploit_module_relative_name]' do
      subject(:metasploit_module_relative_name) do
        locals[:metasploit_module_relative_name]
      end

      it 'is #metasploit_module_relative_name' do
        expect(metasploit_module_relative_name).to eq(template.metasploit_module_relative_name)
      end
    end

    context '[:module_ancestor]' do
      subject(:locals_module_ancestor) do
        locals[:module_ancestor]
      end

      it 'is #module_ancestor' do
        expect(locals_module_ancestor).to eq(template.module_ancestor)
      end
    end
  end

  context '#metapsloit_module_relative_name' do
    subject(:metasploit_module_relative_name) do
      template.metasploit_module_relative_name
    end

    it { should be_a String }

    it 'uses FactoryGirl.generate' do
      # ensure template is memoized so only metasploit_module_relative_name's usage of FactoryGirl is seen
      template

      expect(FactoryGirl).to receive(:generate).with(:metasploit_model_module_ancestor_metasploit_module_relative_name).and_call_original

      metasploit_module_relative_name
    end
  end

  context '#overwrite' do
    subject(:overwrite) do
      template.overwrite
    end

    it { should be_false }
  end

  context '#search_pathnames' do
    subject(:search_pathnames) do
      template.search_pathnames
    end

    it 'uses DEFAULT_SEARCH_PATHNAMES' do
      expect(search_pathnames).to match_array(described_class::DEFAULT_SEARCH_PATHNAMES)
    end
  end

  context '#source_relative_name' do
    subject(:source_relative_name) do
      template.source_relative_name
    end

    it 'uses DEFAULT_SOURCE_RELATIVE_NAME' do
      expect(source_relative_name).to eq(described_class::DEFAULT_SOURCE_RELATIVE_NAME)
    end
  end

  context 'write' do
    subject(:write) do
      described_class.write(attributes)
    end

    before(:each) do
      # Since overwrite is false, have to delete the template that the factories make.
      module_ancestor.real_pathname.delete
    end

    context 'with valid' do
      let(:attributes) do
        {
            module_ancestor: module_ancestor
        }
      end

      it { should be_true }

      it 'writes template' do
        # memoize attributes so any other writes besides the one under-test are already run.
        attributes

        described_class.any_instance.should_receive(:write)

        write
      end
    end

    context 'without valid' do
      let(:attributes) do
        {}
      end

      it { should be_false }

      it 'does not write template' do
        described_class.any_instance.should_not_receive(:write)

        write
      end
    end
  end
end