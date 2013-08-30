require 'spec_helper'

describe Metasploit::Model::Visitation::Visit do
  let(:base_class) do
    described_class = self.described_class

    Class.new do
      include described_class
    end
  end

  context 'visit' do
    subject(:visit) do
      base_class.visit(*module_names, &block)
    end

    context 'with 0 Module#names' do
      let(:block) do
        nil
      end

      let(:module_names) do
        []
      end

      it 'should raise ArgumentError' do
        expect {
          visit
        }.to raise_error(ArgumentError)
      end
    end

    context 'with block' do
      let(:block) do
        lambda { |node|
          node
        }
      end

      context 'with 1 Module#name' do
        let(:module_names) do
          [
              mod.name
          ]
        end

        let(:mod) do
          Module.new
        end

        before(:each) do
          # give mod a Module#name for use in options
          stub_const('Visited', mod)
        end

        it 'should return Array(Metasploit::Model::Visitation::Visitor)' do
          visit.should be_an Array
          visit.length.should == 1
          visit.first.should be_a Metasploit::Model::Visitation::Visitor
        end

        it 'should add Metasploit::Model::Visitation::Visitor to visitor_by_module_name' do
          visitor = visit.first

          base_class.visitor_by_module_name[mod.name].should == visitor
        end
      end

      context 'with multiple Module#names' do
        let(:first_module) do
          Module.new
        end

        let(:module_names) do
          [
              first_module.name,
              second_module.name
          ]
        end

        let(:second_module) do
          Module.new
        end

        before(:each) do
          stub_const('Visited::First', first_module)
          stub_const('Visited::Second', second_module)
        end

        it 'should return Array<Metasploit::Model::Visitation::Visitor>' do
          visit.should be_an Array
          visit.length.should == module_names.length

          visit.all? { |visitor|
            visitor.is_a? Metasploit::Model::Visitation::Visitor
          }.should be_true
        end

        it 'should each Metasploit::Model::Visitation::Visitor to visitor_by_module_name' do
          module_names.all? { |module_name|
            visit.include? base_class.visitor_by_module_name[module_name]
          }.should be_true
        end
      end
    end

    context 'without block' do
      let(:block) do
        nil
      end

      let(:module_names) do
        ['Visited']
      end

      it 'should raise Metasploit::Model::Invalid' do
        expect {
          visit
        }.to raise_error(Metasploit::Model::Invalid)
      end
    end
  end

  context 'visitor' do
    subject(:visitor) do
      base_class.visitor(klass)
    end

    let(:block) do
      lambda { |node|
        node
      }
    end

    let(:klass) do
      Class.new
    end

    let(:klass_visitor) do
      Metasploit::Model::Visitation::Visitor.new(
          :module_name => klass.name,
          :parent => parent,
          &block
      )
    end

    let(:parent) do
      Class.new
    end

    before(:each) do
      stub_const('Visited::Class', klass)
    end

    context 'with klass in visitor_by_module' do
      before(:each) do
        base_class.visitor_by_module[klass] = klass_visitor
      end

      it 'should return visitor from visitor_by_module' do
        visitor.should == klass_visitor
      end
    end

    context 'without klass in visitor_by_module' do
      let(:ancestor) do
        Module.new
      end

      let(:ancestor_visitor) do
        Metasploit::Model::Visitation::Visitor.new(
            :module_name => ancestor.name,
            :parent => parent,
            &block
        )
      end

      before(:each) do
        stub_const('Visited::Ancestor', ancestor)

        klass.send(:include, ancestor)
      end

      context 'with ancestor in visitor_by_module' do
        before(:each) do
          base_class.visitor_by_module[ancestor] = ancestor_visitor
        end

        it 'should return ancestor visitor' do
          visitor.should == ancestor_visitor
        end

        it 'should cache ancestor visitor as visitor for klass in visitor_by_module' do
          visitor

          base_class.visitor_by_module[klass].should == ancestor_visitor
        end
      end

      context "with ancestor Module#name in visitor_by_module_name" do
        before(:each) do
          base_class.visitor_by_module_name[ancestor.name] = ancestor_visitor
        end

        it 'should return ancestor visitor' do
          visitor.should == ancestor_visitor
        end

        it 'should cache ancestor visitor as visitor for klass in visitor_by_module' do
          visitor

          base_class.visitor_by_module[klass].should == ancestor_visitor
        end
      end

      context 'without visitor for ancestor' do
        it 'should raise TypeError' do
          expect {
            visitor
          }.to raise_error(TypeError)
        end
      end
    end
  end

  context 'visitor_by_module' do
    subject(:visitor_by_module) do
      base_class.visitor_by_module
    end

    it 'should default to empty Hash' do
      visitor_by_module.should == {}
    end
  end

  context 'visitor_by_module_name' do
    subject(:visitor_by_module_name) do
      base_class.visitor_by_module_name
    end

    it 'should default to empty Hash' do
      visitor_by_module_name.should == {}
    end
  end

  context '#visit' do
    subject(:visit) do
      base_instance.visit(node)
    end

    let(:base_instance) do
      base_class.new
    end

    let(:block) do
      lambda { |node|
        node
      }
    end

    let(:node) do
      node_class.new
    end

    let(:node_class) do
      Class.new
    end

    before(:each) do
      stub_const('Visited::Class', node_class)

      visitors = base_class.visit node.class.name, &block
      @visitor = visitors.first
    end

    it 'should find visitor for node.class' do
      base_class.should_receive(:visitor).with(node.class).and_call_original

      visit
    end

    it 'should visit on visitor' do
      @visitor.should_receive(:visit).with(base_instance, node)

      visit
    end

    context 'recursion' do
      let(:block) do
        lambda { |node|
          if node.child
            visit node.child
          else
            node
          end
        }
      end

      let(:leaf_node) do
        node_class.new
      end

      before(:each) do
        node_class.class_eval do
          attr_accessor :child
        end

        node.child = leaf_node
      end

      it "should be able to call visit from inside a visitor's block" do
        visit.should == leaf_node
      end
    end
  end
end