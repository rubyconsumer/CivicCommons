class Notifier < Devise::Mailer
  layout 'mailer'
  
  def welcome(record)
    setup_mail(record, :welcome)
  end
  
end
