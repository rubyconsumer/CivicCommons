require_relative 'search_box'

module CivicCommonsDriver
  module Pages
    class IssueDetail
      SHORT_NAME = :issue_detail
      attr_accessor :url
      include Page
      include SearchBox
      
      has_link :people_active_in_this_issue, 'People active in this issue', :issue_community

      def initialize attributes
        self.url = "/issues/#{attributes[:for].cached_slug}"
      end

      def follow_topic_link_for topic
        click_link topic.name
        CivicCommonsDriver.set_current_page_to :issues_index
      end
      def has_filed? issue, options
        has_content? options[:under].name
      end
    end
  end
end
