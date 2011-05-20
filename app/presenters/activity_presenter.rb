class ActivityPresenter
  include Enumerable

  def initialize(collection)
    @collection = collection
    load_activity
  end

  def [](index)
    return self.at(index)
  end

  def at(index)
    item = @collection[index]
    unless item.nil?
      item = @data[item.item_type][item.item_id]
    end
    return item
  end

  def each
    (0 .. self.size-1).each { |i| yield self.at(i) }
  end

  def each_with_type
    (0 .. self.size-1).each { |i| yield [self.at(i), @collection[i].item_type] }
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

  private

  def load_activity

    # sort the activity items for eager loading
    @data = { }
    Activity::VALID_TYPES.each { |type| @data[type.to_s] = [] }
    @collection.each { |obj| @data[obj.item_type] << obj.item_id }

    # load the item data
    @data.each do |type, items|
      case type
      when "Contribution"
        unless @data[type].empty?
          @data[type] = type.constantize.includes([:person, :parent, :conversation, :issue]).where(id: @data[type])
        end
      when "RatingGroup"
        unless @data[type].empty?
          @data[type] = type.constantize.includes([:person, :ratings]).where(id: @data[type])
        end
      when "Conversation"
        unless @data[type].empty?
          @data[type] = type.constantize.includes([:person]).where(id: @data[type])
        end
      else
        unless @data[type].empty?
          @data[type] = type.constantize.where(id: @data[type])
        end
      end
    end

    # index the data values based on item_id
    @data.each do |type, items|
      collection = { }
      unless items.nil?
        items.each do |item|
          collection[item.id] = item
        end
      end
      @data[type] = collection
    end

  end

end
