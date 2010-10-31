class Notifier < Devise::Mailer
  layout 'mailer'
  
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
  
end
