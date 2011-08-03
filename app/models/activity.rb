class Activity < ActiveRecord::Base

  set_table_name "top_items"

  belongs_to :item, polymorphic: true

  validates :item_id, presence: true
  validates :item_type, presence: true
  validates :item_created_at, presence: true
  validates :person_id, presence: true

  VALID_TYPES = [ Conversation, Contribution, Issue, RatingGroup ]

  ############################################################
  # construction/destruction

  # will accept an active record object of valid type
  def initialize(attributes = nil)

    if Activity.valid_type?(attributes)
      attributes = attributes.becomes(Contribution) if attributes.is_a?(Contribution)
      attr = {
        item_id: attributes.id,
        item_type: attributes.class.to_s,
        item_created_at: attributes.created_at,
        person_id: attributes.person.id
      }
      if attributes.respond_to?(:conversation_id) && !attributes.conversation_id.nil?
        attr[:conversation_id] = attributes.conversation_id
        attr[:activity_cache] = Activity.encode(attributes)
      elsif attributes.respond_to?(:issue_id) && !attributes.issue_id.nil?
        attr[:issue_id] = attributes.issue_id
        attr[:activity_cache] = Activity.encode(attributes)
      elsif attributes.is_a?(Conversation)
        attr[:conversation_id] = attributes.id
        attr[:activity_cache] = Activity.encode(attributes)
      end

      attributes = attr

    end

    super(attributes)
  end

  #Updating cache data on update

  def self.update(model)

    model = model.becomes(Contribution) if model.is_a?(Contribution)

    if Activity.valid_type?(model)
      item = Activity.where(item_id: model.id, item_type: model.class.to_s).first
      unless item.nil?
        item.activity_cache = Activity.encode(model)
        item.save
      end
    end

  end

  # will accept an active record object of valid type
  def self.delete(id)
    if Activity.valid_type?(id)
      id = id.becomes(Contribution) if id.is_a?(Contribution)
      Activity.delete_all("item_id = #{id.id} and item_type like '#{id.class}'")
    else
      super(id)
    end
  end

  # will accept an active record object of valid type
  def self.destroy(id)
    if Activity.valid_type?(id)
      id = id.becomes(Contribution) if id.is_a?(Contribution)
      Activity.destroy_all("item_id = #{id.id} and item_type like '#{id.class}'")
    else
      super(id)
    end
  end

  ############################################################
  # class utility methods

  def self.valid_type?(item)
    ok = false
    VALID_TYPES.each do |type|
      if (item.is_a? Contribution and not item.top_level_contribution?)
        ok = true
        break
      elsif item.is_a? type and not item.is_a? Contribution
        ok = true
        break
      elsif item.is_a? GenericObject and item.__class__ == 'Contribution' and not item.top_level_contribution?
        ok = true
        break
      elsif item.is_a? GenericObject and item.__class__ == type.to_s and not item.__class__ == 'Contribution'
        ok = true
        break
      end
    end
    return ok
  end

  def self.encode(item)
    obj = nil
    if Activity.valid_type?(item)
      if item.is_a? Conversation
        obj = ActiveSupport::JSON.encode(item, include: [:person])
      elsif item.is_a? Contribution
        obj = ActiveSupport::JSON.encode(item, include: [:person, :conversation])
      elsif item.is_a? RatingGroup
        # need to load rating descriptors
        obj = ActiveSupport::JSON.encode(item, include: [:person, :ratings, :conversation])
      end
    end
    return obj
  end

  def self.decode(item)
    hash = ActiveSupport::JSON.decode(item)
    return self.to_active_record(hash.keys.first, hash.values.first)
  end

  ############################################################
  # custom finders

  def self.most_recent_activity(limit = nil)
    if limit.nil?
      Activity.order('item_created_at DESC')
    else
      Activity.order('item_created_at DESC').limit(limit)
    end
  end

  def self.most_recent_activity_for_issue(issue, limit = nil)
    if limit.nil?
      Activity.where(issue_id: issue.id).order('item_created_at DESC')
    else
      Activity.where(issue_id: issue.id).limit(limit).order('item_created_at DESC')
    end
  end

  def self.most_recent_activity_for_conversation(conversation, limit = nil)
    if limit.nil?
      Activity.where(conversation_id: conversation.id).order('item_created_at DESC')
    else
      Activity.where(conversation_id: conversation.id).limit(limit).order('item_created_at DESC')
    end
  end

  def self.recent_items_for_person(person, limit = nil)
    if limit.nil?
      Activity.where(person_id: person.id).order('item_created_at DESC')
    else
      Activity.where(person_id: person.id).limit(limit).order('item_created_at DESC')
    end
  end

  private

  ############################################################
  # encode/decode helpers

  def self.to_active_record(clazz, data)
    clazz = clazz.classify.constantize
    data.each do |key, value|
      if value.is_a? Hash
        data[key] = self.to_active_record(key, value)
      elsif value.is_a? Array
        value.each_with_index do |data, index|
          value[index] = self.to_active_record(key, data) if value[index].is_a? Hash
        end
      end
    end
    data['__class__'] = clazz.to_s
    obj = GenericObject.new(data)
    return obj
  end

end
