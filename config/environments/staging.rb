Civiccommons::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = false
  config.action_view.debug_rjs             = false
  config.action_controller.perform_caching = true

  # DO care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.sendgrid.net",
    :domain               => "theciviccommons.com",
    :user_name            => "joe@joefiorini.com",
    :password             => "digitalcity",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }

  config.active_support.deprecation = :log

  # For devise gem
  config.action_mailer.default_url_options = { :host => 'staging.theciviccommons.com' }

  # For ExceptionNotifier
  config.middleware.use ExceptionNotifier,
      :email_prefix => "[Staging Error] ",
      :sender_address => %{"Staging Notifier" <staging.notifier@theciviccommons.com>},
      :exception_recipients => %w{winston.tsang@radberry.com}
end
