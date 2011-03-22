class MailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{Rails.env.to_s.camelcase} - #{message.to}] #{message.subject}"
    message.to = Civiccommons::Config.mailer['intercept_email']
  end
end

