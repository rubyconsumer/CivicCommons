require_relative 'search_box'

module CivicCommonsDriver
  module Pages
    class Issues
      SHORT_NAME = :issues_index
      LOCATION = '/issues'
      include Page
      include SearchBox

      def has_listed? issue
        has_content? issue.name 
      end
      def has_stated?(issue, options)
        has_content? "Filed under: #{options[:filed_under].name}"
      end
    end
  end
end
