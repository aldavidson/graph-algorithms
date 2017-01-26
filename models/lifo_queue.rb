# lifo_queue.rb
#
# Minimal Queue implementation
#
class LiFoQueue
  def initialize(size=0)
    @items = Array.new(size)
  end

  def push!(*items)
    @items += Array(items).flatten unless items.nil?
  end

  def pop!(number_of_items = 1)
    popped = @items.pop(number_of_items)
    number_of_items == 1 ? popped.first : popped.reverse
  end

  def size
    @items.size
  end

  def empty?
    @items.nil? || @items.empty?
  end

  def last
    @items.last
  end
end