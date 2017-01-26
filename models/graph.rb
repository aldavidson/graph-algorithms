# Graph
#
# Encapsulates a graph of Nodes and Edges
# May be directed or not
# May be weighted or not
#
# Internally, stores graph as an array of nodes, and an
# array of edges
require 'models/fifo_queue'

class Graph
  attr_reader :nodes, :edges
  attr_accessor :weighted, :directed

  def initialize(args = {})
    @weighted = args[:weighted] || false
    @directed = args[:directed] || false
    @nodes = args[:nodes] || []
    @edges = args[:edges] || []
  end

  # NOTE: this will scale linearly in n edges
  # - to improve, we could keep an index / hash of
  # edges by node as we build the graph
  def edges_from(node)
    @edges.select { |e| e.node_from == node }
  end
  def edges_to(node)
    @edges.select { |e| e.node_to == node }
  end

  def neighbours_of(node)
    edges_from(node).map{ |e| e.node_to }
  end

  def add_node!(node)
    @nodes << node
  end

  def add_edge!(edge)
    @edges << edge
  end

  def nodes_with(attrs = {})
    @nodes.select { |node| attrs.all? { |k, v| node.send(k) == v } }
  end

  def edges_with(attrs = {})
    @edges.select { |edge| attrs.all? { |k, v| edge.send(k) == v } }
  end

  # visitor should be an object that MAY respond to
  # the following callback methods:
  # :process_node_early
  # => called with the current node _before_ any of its edges
  # :process_edge
  # => called with each edge discovered for a node
  # :process_node_late
  # => called with the current node _after_ processing its edges
  #
  def breadth_first_search(visitor, start_node = 0)
    traverse(visitor, start_node, FiFoQueue.new)
  end

  def depth_first_search( visitor, start_node = 0)
    traverse(visitor, start_node, LiFoQueue.new)
  end

  def traverse(visitor, start_node, queue)
    discovered = {}
    processed = {}

    # this way avoids appending nil elements to the array
    # which you would get with << if @nodes is empty
    queue.push!(@nodes[start_node])

    until queue.empty?
      current_node = queue.pop!
      if visitor.respond_to? :process_node_early
        visitor.process_node_early(current_node)
      end
      processed[current_node] = true
      current_edges = edges_from(current_node)

      current_edges.each do |edge|
        if !processed[edge] || directed?
          visitor.process_edge(edge) if visitor.respond_to? :process_edge
          processed[edge] = true
        end

        unless discovered[edge]
          queue.push!(edge.node_to)
          discovered[edge] = true
        end
      end

      if visitor.respond_to? :process_node_late
        visitor.process_node_late(current_node)
      end
    end
  end

 


end