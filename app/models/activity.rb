class Activity < ActiveRecord::Base

  set_table_name "top_items"

  validates :item_id, presence: true
  validates :item_type, presence: true
  validates :item_created_at, presence: true

  VALID_TYPES = [ Conversation, Contribution, Issue, RatingGroup ]

  def initialize(attributes = nil)

    if valid_type?(attributes)
      attributes = {
        item_id: attributes.id,
        item_type: attributes.class.to_s,
        item_created_at: attributes.created_at
      }
    end

    super(attributes)
  end

  def valid_type?(item)
    ok = false
    VALID_TYPES.each do |type|
      if item.is_a?(type) && item.class != TopLevelContribution
        ok = true
        break
      end
    end
    return ok
  end

end
