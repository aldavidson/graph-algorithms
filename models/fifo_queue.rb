# queue.rb
#
# Minimal Queue implementation
#
class FiFoQueue
  def initialize(size=0)
    @items = Array.new(size)
  end

  def push!(*items)
    @items += Array(items).flatten unless items.nil?
  end

  def pop!(number_of_items = 1)
    popped = @items.take(number_of_items)
    @items = @items[number_of_items..@items.size]
    number_of_items == 1 ? popped.first : popped
  end

  def size
    @items.size
  end

  def empty?
    @items.nil? || @items.empty?
  end

  def first
    @items.first
  end
end