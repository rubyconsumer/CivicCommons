source 'http://rubygems.org'

gem 'mysql2', '< 0.3'
gem 'devise'
gem "oa-oauth", :require => "omniauth/oauth"
gem 'omniauth', '~>0.2.0'

gem 'rails', "3.0.3"
gem 'jquery-rails', '>= 1.0.3'

gem 'haml', "<3.1"
gem 'date_validator'
gem "will_paginate", "2.3.15"

gem 'httparty'

gem 'geokit'

gem "friendly_id", "~> 3.2.1"
gem 'acts_as_revisionable'
gem 'awesome_nested_set'
gem 'embedly', '<0.4'

gem 'gibbon'
gem 'hominid', "~>3.0.2"
gem 'delayed_job', ">= 2.1.2"

gem 'hoptoad_notifier'

gem 'remotipart'

gem 'shoulda'
gem 'paperclip', "2.3.8"
gem 'delayed_paperclip', '<0.7'
gem 'aws-s3'
gem 'nokogiri'
gem 'sanitize'
gem 'highline'

gem "gchart", "~> 1.0.0"

gem 'sunspot_rails' 

gem 'fitter-happier', '= 0.0.1'

gem 'sixarm_ruby_email_address_validation'

group :development do
  gem "rails3-generators"
  gem "hpricot"
  gem "ruby_parser"
  gem "engineyard"
  gem "ruby-debug19"
end

group :test do
  gem "rack-test"
  gem 'cucumber', '~>0.10.0'
  gem "factory_girl_rails", '~>1.0.1'
  gem 'no_peeping_toms', :git => 'git://github.com/alindeman/no_peeping_toms.git'
  gem "ruby-debug19"
  gem 'webmock'
  # Required by WebMock but breaks everything at 2.2.5
  # Can use latest addressable when pull request is accepted: https://github.com/sporkmonger/addressable/pull/33
  gem 'addressable', :git => 'git://github.com/gkellogg/addressable.git', :branch => 'frozen-uri'
  gem 'linguistics'
  gem 'fuubar', '~>0.0.3'
  gem "cucumber-rails", "0.4.0.beta.1"
  gem "database_cleaner", "~> 0.6.0"
  gem 'email_spec'
  gem 'simplecov'
  gem 'timecop'
  gem 'selenium-webdriver'
  gem 'rspec-spies'
  gem 'spork'
end


group :development, :test do
  gem "jasmine"
  gem "rspec-rails", "~> 2.5.0"
  gem 'steak'
  gem "capybara"
  gem 'webrat', "~> 0.7.3"
  gem 'rspec-spies'
end

group :cool_toys do
  gem 'autotest'
  gem 'autotest-rails' 
  gem 'autotest-growl'
  gem 'autotest-fsevent'
  gem "jasmine-headless-webkit"
  gem 'query_reviewer', :git => 'git://github.com/nesquena/query_reviewer.git'
  gem 'launchy'
end
