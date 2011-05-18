class Activity < ActiveRecord::Base

  set_table_name "top_items"

  validates :item_id, presence: true
  validates :item_type, presence: true
  validates :item_created_at, presence: true

  VALID_TYPES = [ Conversation, Contribution, Issue, RatingGroup ]

  def initialze(attributes = nil)
    if is_valid_type?(attributes)
      @item_id = attributes.id
      @item_type = attributes.class.to_s
      @item_created_at = attributes.created_at
    else
      return super(attributes)
    end
  end

  def is_valid_type?(item)
    ok = false
    VALID_TYPES.each do |type|
      if item.is_a?(type)
        ok = true
        break
      end
      return ok
    end
  end

end
