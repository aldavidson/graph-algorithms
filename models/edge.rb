# edge.rb
#
# Represents an Edge in a Graph
#
class Edge
  attr_accessor :node_from, :node_to
  # defaults to 1 if not given
  attr_accessor :weight

  def initialize(args = {})
    @node_from  = args[:node_from]
    @node_to    = args[:node_to]
    @weight     = args[:weight] || 1
  end
end