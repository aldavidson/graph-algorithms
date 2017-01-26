# node.rb
#
# Represents a node in a Graph
#
class Node
  attr_accessor :value

  def initialize(args = {})
    @value = args[:value]
  end
end