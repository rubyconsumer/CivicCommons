class ActivityPresenter
  include Enumerable

  def initialize(collection)
    @collection = collection
    @collection.collect
  end

  def [](index)
    return self.at(index)
  end

  def at(index)
    item = @collection[index]
    unless item.nil?
      item = Activity.decode(@collection[index].activity_cache)
    end
    return item
  end

  def each
    (0 .. self.size-1).each { |i| yield self.at(i) }
  end

  def each_with_type
    (0 .. self.size-1).each { |i| yield [self.at(i), self.type_at(i)] }
  end

  def empty?
    return @collection.empty?
  end

  def first
    return self.at(0)
  end

  def last
    return self.at(self.size-1)
  end

  def size
    return @collection.size
  end

  def type_at(index)
    return @collection[index].item_type
  rescue
    return nil
  end

end
