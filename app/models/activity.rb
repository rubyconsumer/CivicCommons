class Activity < ActiveRecord::Base

  set_table_name "top_items"

  belongs_to :item, polymorphic: true

  validates :item_id, presence: true
  validates :item_type, presence: true
  validates :item_created_at, presence: true

  VALID_TYPES = [ Conversation, Contribution, Issue, RatingGroup ]

  def initialize(attributes = nil)

    if Activity.valid_type?(attributes)
      attributes = attributes.becomes(Contribution) if attributes.is_a?(Contribution)
      attr = {
        item_id: attributes.id,
        item_type: attributes.class.to_s,
        item_created_at: attributes.created_at
      }
      if attributes.respond_to?(:conversation_id) && !attributes.conversation_id.nil?
        attr[:conversation_id] = attributes.conversation_id
      elsif attributes.respond_to?(:issue_id) && !attributes.issue_id.nil?
        attr[:issue_id] = attributes.issue_id
      elsif attributes.is_a?(Conversation)
        attr[:conversation_id] = attributes.id
      end

      attributes = attr

    end

    super(attributes)
  end

  def self.valid_type?(item)
    ok = false
    VALID_TYPES.each do |type|
      if item.is_a?(type) && item.class != TopLevelContribution
        ok = true
        break
      end
    end
    return ok
  end

  def self.delete(id)
    if Activity.valid_type?(id)
      id = id.becomes(Contribution) if id.is_a?(Contribution)
      Activity.delete_all("item_id = #{id.id} and item_type like '#{id.class}'")
    else
      super(id)
    end
  end

  def self.destroy(id)
    if Activity.valid_type?(id)
      id = id.becomes(Contribution) if id.is_a?(Contribution)
      Activity.destroy_all("item_id = #{id.id} and item_type like '#{id.class}'")
    else
      super(id)
    end
  end

  def self.most_recent_activity(limit = nil)
    if limit.nil?
      Activity.order('created_at desc')
    else
      Activity.order('created_at desc').limit(limit)
    end
  end

  def self.most_recent_activity_for_issue(issue, limit = nil)
    if limit.nil?
      Activity.where(issue_id: issue.id).order('created_at DESC')
    else
      Activity.where(issue_id: issue.id).limit(limit).order('created_at DESC')
    end
  end

  def self.most_recent_activity_for_conversation(conversation, limit = nil)
    if limit.nil?
      Activity.where(conversation_id: conversation.id).order('created_at DESC')
    else
      Activity.where(conversation_id: conversation.id).limit(limit).order('created_at DESC')
    end
  end

end
