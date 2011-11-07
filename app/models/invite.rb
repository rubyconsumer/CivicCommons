class Invite #makes invitation behaves like an activerecord model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  EMAIL_SPLIT = /[\s\,]+/i
  
  attr_accessor :emails, 
                :conversation,
                :user,
                :source_type, 
                :source_id
  
  validates_presence_of :emails,
                        :source_type,
                        :source_id,
                        :user
                        
  validate :email_formatting
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def conversation
    @conversation ||= (Conversation.find_by_id(source_id) || Conversation.first)
  end
  
  # email_formatting validation
  def email_formatting
    unless splitted_emails.all?{|email| email =~ EmailAddressValidation::EMAIL_ADDRESS_EXACT_PATTERN }
      errors.add(:emails, "must be in the correct format, example: abc@test.com") 
    end
  end
  
  def persisted?
    false
  end
  
  def splitted_emails
    emails.to_s.split(EMAIL_SPLIT)
  end
  
  # returns an array of emails using Regex
  def parsed_emails
    splitted_emails.find_all{|email| email =~ EmailAddressValidation::EMAIL_ADDRESS_EXACT_PATTERN}
  end
  
  def send_invites
    if valid?
      case source_type
      when 'conversations'
        send_conversation_invites
      end
    else
      return false
    end
  end
  
  def send_conversation_invites
    parsed_emails.each do |email|
      resource = {:emails => email, :user => user, :conversation => conversation}
      mail = Notifier.invite_to_conversation(resource)
      mail_result = mail.deliver
    end
  end
end
