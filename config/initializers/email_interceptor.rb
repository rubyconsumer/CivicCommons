cc = Civiccommons::Config
if cc.mailer['intercept']
  ActionMailer::Base.register_interceptor(MailInterceptor)
end

