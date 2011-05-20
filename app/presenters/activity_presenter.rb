class ActivityPresenter < PresenterBase
  include Enumerable

  def initialize(object, request=nil)
    super(object, request)
    load_activity
  end

  def [](index)
    item = @object[index]
    item = @data[item.item_type][item.item_id]
    return item
  end

  def each
    (0 .. self.size-1).each { |i| yield self[i] }
  end

  private

  def load_activity

    # sort the activity items for eager loading
    @data = { }
    Activity::VALID_TYPES.each { |type| @data[type.to_s] = [] }
    @object.each { |obj| @data[obj.item_type] << obj.item_id }

    # load the item data
    Activity::VALID_TYPES.each do |type|
      type = type.to_s
      case type
      when "Contribution"
        unless @data[type].empty?
          @data[type] = type.constantize.includes([:person, :parent, :conversation, :issue]).where(id: @data[type])
        end
      when "RatingGroup"
        unless @data[type].empty?
          @data[type] = type.constantize.includes([:person, :ratings]).where(id: @data[type])
        end
      when "Issue"
        unless @data[type].empty?
          @data[type] = type.constantize.where(id: @data[type])
        end
      else
        unless @data[type].empty?
          @data[type] = type.constantize.includes([:person]).where(id: @data[type])
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
