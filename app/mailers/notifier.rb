class Notifier < Devise::Mailer
  layout 'mailer'
  
  def welcome(record)
    @account = record
    mail(:subject => "Welcome to The Civic Commons",
         :from => Devise.mailer_sender,
         :to => record.email)

  end
  
end
