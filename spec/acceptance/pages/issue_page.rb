require_relative 'search_box'

module CivicCommonsDriver
  module Pages
    class IssueDetail
      SHORT_NAME = :issue_detail
      attr_accessor :url
      include Page
      include SearchBox
      def initialize attributes
        self.url = "/issues/#{attributes[:for].cached_slug}"
      end
      def has_filed? issue, options
        has_content? options[:under].name
      end
    end
  end
end
