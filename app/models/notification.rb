# The Notification model is based off of the Activity model.
# The main difference is that the Notification model is per person.
class Notification < ActiveRecord::Base
  belongs_to :item, polymorphic: true
  belongs_to :person

  validates :item_id, presence: true
  validates :item_type, presence: true
  validates :item_created_at, presence: true
  validates :person_id, presence: true

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
end
