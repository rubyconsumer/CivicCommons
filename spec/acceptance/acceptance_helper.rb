require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "steak"

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Put your page object inside /spec/acceptance/pages
Dir["#{File.dirname(__FILE__)}/pages/**/*.rb"].each {|f| require f}

require 'acceptance/steps'
