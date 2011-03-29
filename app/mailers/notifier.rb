class Notifier < Devise::Mailer

  layout 'mailer'
  add_template_helper(ConversationsHelper)

  def welcome(record)
    @resource = record
    mail(:subject => "Welcome to The Civic Commons",
         :from => Devise.mailer_sender,
         :to => @resource.email)
  end

  def new_registration_notification(record)
    @resource = record
    mail(:subject => "New User Registered",
         :from => Devise.mailer_sender,
         :to => 'register@theciviccommons.com')
  end

  def suggestion_thank_you(record)
    @resource = record
    mail(:subject => "Thank you for your suggestion",
         :from => Devise.mailer_sender,
         :to => @resource.email)
  end

  def invite_to_conversation(resource)
    @resource = resource
    @user = @resource[:user]
    @conversation = @resource[:conversation]
    mail(:subject => @user.name + " wants to invite you to a conversation at The Civic Commons",
         :from => Devise.mailer_sender,
         :to => @resource[:emails])
  end

  def daily_digest(person, conversations)
    @person = person
    @conversations = conversations
    mail(:subject => "Civic Commons Daily Digest",
         :from => '"Curator of Conversation" <curator@theciviccommons.com>',
         :to => @person.email)
  end

end
