if ENV['__test_coverage__']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/autotest/'
    add_filter '/config/'
    add_filter '/db/'
    add_filter '/deploy/'
    add_filter '/doc/'
    add_filter '/features/'
    add_filter '/lib/jobs/'
    add_filter '/lib/tasks/'
    add_filter '/log/'
    add_filter '/public/'
    add_filter '/script/'
    add_filter '/spec/'
    add_filter '/test/'
    add_filter '/tmp/'
    add_filter '/vendor/'
    add_group 'Concerns', 'app/concerns'
    add_group 'Controllers', 'app/controllers'
    add_group 'Helpers', 'app/helpers'
    add_group 'Libraries', 'lib'
    add_group 'Mailers', 'app/mailers'
    add_group 'Models', 'app/models'
    add_group 'Presenters', 'app/presenters'
    add_group 'Observers', 'app/observers'
    add_group 'Services', 'app/services'
    #add_group 'Views', 'app/views'
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'

require 'ostruct'

require 'pp'

require 'paperclip/matchers'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  config.include CustomMatchers
  config.include WebMock::API
  config.include StubbedHttpRequests
  config.include Paperclip::Shoulda::Matchers

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before :each do
    stub_contribution_urls
    stub_amazon_s3_request
  end
end

include Devise::TestHelpers
