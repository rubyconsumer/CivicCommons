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
  page.driver.within_frame("#{name}_ifr") do
    editor = page.find_by_id('tinymce')
    editor.native.send_keys(args[:with])
  end
end