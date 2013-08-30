require 'spec_helper'

describe Metasploit::Model::Search::Association do
  subject(:base_class) do
    described_class = self.described_class

    Class.new do
      include described_class
    end
  end

  context 'search_association' do
    it 'should add Symbol to search_association_set' do
      association_string = 'associated_things'

      base_class.class_eval do
        search_association association_string
      end

      base_class.search_association_set.should include(association_string.to_sym)
    end
  end

  context 'search_association_set' do
    let(:search_association_set) do
      base_class.search_association_set
    end

    it 'should default to an empty Set' do
      search_association_set.should == Set.new
    end
  end
end