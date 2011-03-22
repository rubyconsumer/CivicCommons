cc = Civiccommons::Config
if cc.mailer.key?('intercept') and cc.mailer['intercept']
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end
