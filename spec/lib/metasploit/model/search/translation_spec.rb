require 'spec_helper'

describe Metasploit::Model::Search::Translation do
  subject(:base_class) do
    Class.new
  end

  context 'extend' do
    let(:base_class) do
      Class.new
    end

    before(:each) do
      stub_const('Metasploit::Model::Search::Translation::Class', base_class)
    end

    it 'should call search_i18n_scope' do
      base_class.should_receive(:search_i18n_scope)

      base_class.extend described_class
    end
  end

  context 'search_i18n_scope' do
    subject(:search_i18n_scope) do
      descendant
    end

    let(:ancestor) do
      Module.new
    end

    let(:descendant) do
      ancestor = self.ancestor

      Class.new do
        include ancestor
      end
    end

    before(:each) do
      stub_const('Metasploit::Model::Search::Translation::Ancestor', ancestor)
      stub_const('Metasploit::Model::Search::Translation::Descendant', descendant)
    end

    context 'with ancestor with search_i18n_scope' do
      before(:each) do
        ancestor.extend described_class
        descendant.extend described_class
      end

      it "should use ancestor's search_i18n_scope" do
        descendant.search_i18n_scope.should == ancestor.search_i18n_scope
      end
    end

    context 'without ancestor with search_i18n_scope' do
      before(:each) do
        descendant.extend described_class
      end

      it "should derive search_i18n_scope from Class#name" do
        descendant.search_i18n_scope.should == 'metasploit.model.search.translation.descendant'
      end
    end
  end
end