class Notifier < Devise::Mailer

  layout 'mailer'
  add_template_helper(ConversationsHelper)

  def email_changed(old_email, new_email)
    @old_email = old_email
    @new_email = new_email
    headers['X-SMTPAPI'] = '{"category": "email_changed"}'
    mail(:subject => "You've recently changed your email with The Civic Commons",
         :from => Devise.mailer_sender,
         :to => [old_email, new_email])
  end

  def welcome(record)
    @resource = record
    headers['X-SMTPAPI'] = '{"category": "welcome"}'
    mail(:subject => "Welcome to The Civic Commons",
         :from => Devise.mailer_sender,
         :to => @resource.email)
  end

  def new_registration_notification(record)
    @resource = record
    headers['X-SMTPAPI'] = '{"category": "new_registration_notification"}'
    mail(:subject => "New User Registered",
         :from => Devise.mailer_sender,
         :to => 'register@theciviccommons.com')
  end

  def suggestion_thank_you(record)
    @resource = record
    headers['X-SMTPAPI'] = '{"category": "suggestion_thank_you"}'
    mail(:subject => "Thank you for your suggestion",
         :from => Devise.mailer_sender,
         :to => @resource.email)
  end

  def invite_to_conversation(resource)
    @resource = resource
    @user = @resource[:user]
    @conversation = @resource[:conversation]
    headers['X-SMTPAPI'] = '{"category": "invite_to_conversation"}'
    mail(:subject => @user.name + " wants to invite you to a conversation at The Civic Commons",
         :from => Devise.mailer_sender,
         :to => @resource[:emails])
  end

  def violation_complaint(resource)
    @resource = resource
    @user = @resource[:user]
    @reason = @resource[:reason]
    @contribution = @resource[:contribution]
    headers['X-SMTPAPI'] = '{"category": "violation_complaint"}'
    mail(:subject => "ALERT: Possible TOS Violation reported",
         :from => Devise.mailer_sender,
         :to => Civiccommons::Config.email["default_email"])
  end

  def daily_digest(person, conversations, new_conversations)
    @person = person
    @conversations = conversations
    @new_conversations = new_conversations
    headers['X-SMTPAPI'] = '{"category": "daily_digest"}'
    mail(:subject => "The Civic Commons Daily Digest",
         :from => '"Curator of Conversation" <curator@theciviccommons.com>',
         :to => @person.email)
  end

end
