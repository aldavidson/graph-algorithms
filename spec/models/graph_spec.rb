require_relative '../app_helper'

require 'models/graph'
require 'models/node'
require 'models/edge'

class Visitor
  attr_accessor :nodes_visited_early, :nodes_visited_late, :edges_visited

  def initialize
    @nodes_visited_early = []
    @nodes_visited_late  = []
    @edges_visited       = []
  end

  def process_node_early(node)
    @nodes_visited_early << node
  end
  def process_node_late(node)
    @nodes_visited_late << node
  end
  def process_edge(edge)
    @edges_visited << edge
  end

end

describe Graph do

  describe '#add_node!' do
    context 'given a node' do
      let(:node){ Node.new(value: 'my node') }

      it "adds the given node to the graph" do
        expect{ subject.add_node!(node) }.to change( subject.nodes, :first ).from(nil).to(node)
      end
    end
  end

  describe '#add_edge!' do
    context 'given a edge' do
      let(:edge){ Edge.new() }

      it "adds the given edge to the graph" do
        expect{ subject.add_edge!(edge) }.to change( subject.edges, :first ).from(nil).to(edge)
      end
    end
  end
  
  describe "when the graph has nodes and edges" do
    let(:al){ Node.new(value: 'al') }
    let(:pete){ Node.new(value: 'pete') }
    let(:dave){ Node.new(value: 'dave') }
    let(:tom){ Node.new(value: 'tom') }
    let(:al_pete){ Edge.new(node_from: al, node_to: pete) }
    let(:al_dave){ Edge.new(node_from: al, node_to: dave) }
    let(:dave_tom){ Edge.new(node_from: dave, node_to: tom) }

    before do
      [al, pete, dave].each{ |node| subject.add_node!(node) }
      subject.add_edge!(al_pete)
      subject.add_edge!(al_dave)
      subject.add_edge!(dave_tom)
    end
  
    describe "#edges_from" do
      it 'returns all the edges from the given node' do
        result = subject.edges_from(al)
        expect(result).to eq([al_pete, al_dave]) 
      end
    end

    describe "#edges_to" do
      it 'returns all the edges to the given node' do
        result = subject.edges_to(dave)
        expect(result).to eq([al_dave]) 
      end
    end

    describe "#neighbours_of" do
      it 'returns all nodes at the end of an edge from the given node' do
        expect(subject.neighbours_of(al)).to eq([pete, dave])
      end
    end

    describe "#nodes_with" do
      it "returns all nodes where all given attributes match" do
        expect(subject.nodes_with(value: 'dave')).to eq([dave])
      end
    end

    describe "#edges_with" do
      it "returns all edges where all given attributes match" do
        expect(subject.edges_with(node_to: dave)).to eq([al_dave])
      end
    end


    describe "#breadth_first_search" do
      let(:visitor){ Visitor.new }
      before do
        subject.breadth_first_search(visitor)
      end

      it "processes all nodes early" do
        subject.nodes.each do |node|
          expect(visitor.nodes_visited_early).to include(node)
        end
      end

      it "processes all nodes late" do
        subject.nodes.each do |node|
          expect(visitor.nodes_visited_early).to include(node)
        end
      end

      it "processes all edges" do
        subject.edges.each do |edge|
          expect(visitor.edges_visited).to include(edge)
        end
      end

      it "visits nodes breadth-first" do
        expect( visitor.nodes_visited_early ).to eq( [al, pete, dave, tom])
      end
    end

    describe "#depth_first_search" do
      let(:visitor){ Visitor.new }
      before do
        subject.depth_first_search(visitor)
      end

      it "processes all nodes early" do
        subject.nodes.each do |node|
          expect(visitor.nodes_visited_early).to include(node)
        end
      end

      it "processes all nodes late" do
        subject.nodes.each do |node|
          expect(visitor.nodes_visited_early).to include(node)
        end
      end

      it "processes all edges" do
        subject.edges.each do |edge|
          expect(visitor.edges_visited).to include(edge)
        end
      end

      it "visits nodes depth-first" do
        expect( visitor.nodes_visited_early ).to eq( [al, dave, tom, pete])
      end
    end
  end
  
end