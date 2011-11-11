require_relative 'search_box'

module CivicCommonsDriver
  module Pages
    class Issues
      SHORT_NAME = :issues_index
      LOCATION = '/issues'
      include Page
      include SearchBox

      def has_filed?(issue, options)
        within "div.issue-details[data-issue-id='#{issue.id}']" do
          has_content? options[:under].name
        end
      end

      def filtered_by?(topic)
        current_url.include? "topic=#{topic.id}"
      end
    end
  end
end
