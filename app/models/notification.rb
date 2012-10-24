# The Notification model is based off of the Activity model.
# The main difference is that the Notification model is per person.
class Notification < ActiveRecord::Base
  belongs_to :item, polymorphic: true
  belongs_to :person
  belongs_to :receiver, :class_name => 'Person'

  validates :item_id, presence: true
  validates :item_type, presence: true
  validates :item_created_at, presence: true
  validates :person_id, presence: true
  validates :receiver_id, presence: true

  VALID_TYPES = [ Conversation, Contribution, Issue, RatingGroup, SurveyResponse,
                  Petition, PetitionSignature, Reflection, ReflectionComment, Survey]

  # Accept an Active Record object of valid type
  def initialize(attributes = nil)
    if Notification.valid_type?(attributes)
      attributes = attributes.becomes(Contribution) if attributes.is_a?(Contribution)
      attr = {
        item_id: attributes.id,
        item_type: attributes.class.to_s,
        item_created_at: attributes.created_at,
        person_id: attributes.person.id
      }
      if attributes.respond_to?(:conversation_id) && !attributes.conversation_id.nil?
        attr[:conversation_id] = attributes.conversation_id
      elsif attributes.respond_to?(:issue_id) && !attributes.issue_id.nil?
        attr[:issue_id] = attributes.issue_id
      elsif attributes.is_a?(Conversation)
        attr[:conversation_id] = attributes.id
      elsif attributes.is_a?(Vote)
        attr[:conversation_id] = attributes.surveyable_id if attributes.surveyable_type == 'Conversation'
      end

      attributes = attr
    elsif attributes.is_a?(ActiveRecord::Base) 
      # if it's not a valid Notification type, and it's an activerecord object, then nullify it, because it breaks in rails >= 3.1 (Perry)
      attributes = nil
    end
    super(attributes)
  end
  
  # Check if item is a valid type for Activity
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
  
  def self.contributed_on_created_conversation_notification(contribution)
    if contribution.conversation
      Notification.update_or_create_notification(contribution, contribution.conversation.owner)
    end
  end
  
  def self.contributed_on_contribution_notification(contribution)
    if contribution.parent
      Notification.update_or_create_notification(contribution, contribution.parent.owner)
    end
  end
  
  def self.destroy_contributed_on_created_conversation_notification(contribution)
    if contribution.conversation
      Notification.destroy_notification(contribution, contribution.conversation.owner)
    end
  end
  
  def self.destroy_contributed_on_contribution_notification(contribution)
    if contribution.parent
      Notification.destroy_notification(contribution, contribution.parent.owner)
    end
  end
  
  def self.destroy_notification(item, receiver_id)
    Notification.destroy_all(:item_id => item.id, :item_type => item.class.name, :receiver_id =>  receiver_id)
  end
    
  def self.update_or_create_notification(item, receiver_id)
    notification = Notification.where(:item_id => item.id, :item_type => item.class.name, :receiver_id => receiver_id).first 
    if notification
      notification.attributes = Notification.new(item).attributes
    else
      notification = Notification.new(item)
      notification.receiver_id = receiver_id
    end
    notification.save
    return notification
  end

  def self.create_for(item)
    case item
    when Contribution
      self.contributed_on_created_conversation_notification(item)
      self.contributed_on_contribution_notification(item)
    else
    end
  end
  
  def self.destroy_for(item)
    case item
    when Contribution
      self.destroy_contributed_on_created_conversation_notification(item)
      self.destroy_contributed_on_contribution_notification(item)
    else
    end
  end
end
