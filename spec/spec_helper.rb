# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)
require 'rspec/rails'
require 'webmock/rspec'

require 'ostruct'

require 'paperclip/matchers'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  config.mock_with :rspec
  config.include CustomMatchers
  config.include WebMock::API
  config.include StubbedHttpRequests
  config.include Paperclip::Shoulda::Matchers
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.before :each do
    stub_contribution_urls
    stub_amazon_s3_request
  end
end

include Devise::TestHelpers
