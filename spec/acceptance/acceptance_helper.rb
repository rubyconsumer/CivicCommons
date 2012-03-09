require_relative "../spec_helper"
require "steak"

require_relative 'support/database'
require_relative 'support/app'
require_relative 'support/facebookable'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/pages/**/*.rb"].each {|f| require f}

WebMock.allow_net_connect!
Capybara.default_wait_time = 10

def tiny_mce_fill_in(name, args)
  value = args[:with]
  begin
    page.execute_script("$('##{name}').tinymce('setContent', '#{value}')")
  rescue Capybara::NotSupportedByDriverError
    fill_in  "#{name}", :with => value
  end
end
