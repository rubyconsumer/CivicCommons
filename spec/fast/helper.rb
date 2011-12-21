$LOAD_PATH << "."
require 'rspec-spies'
require 'lib/unsubscribe_someone'
unless defined? Rails
  class Rails

    def self.application
      Application.new
    end
    class Application
      def routes
        Routes.new
      end
    end

    class Routes
      def url_helpers
        Fake
      end
    end
  end

  module Fake
    def user_path(user, options)
        "/blarp/#{user.cached_slug}.#{options[:format]}"
    end
  end
end
