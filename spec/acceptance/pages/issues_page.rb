require_relative 'search_box'

module CivicCommonsDriver
  module Pages
    class Issues
      SHORT_NAME = :issues_index
      LOCATION = '/issues'
      include Page
      include SearchBox
      include Database


      def has_filed?(issue, options)
        showing_within? issue, options[:under]
      end

      def has_listed?(topic)
        showing? topic
      end

      def filtered_by?(topic)
        filtered = true
        filtered = false unless at_filtered_issue_page_for? topic
        filtered = false unless link_highlighted_for? topic

        database.issues.each do | issue | 
          filtered = false unless showing_within? issue, topic
        end
        return filtered
      end

      def has_number_of_issues_for?(topic, number)
        within 'ul.simple-list.block-link-list' do
           has_content? "#{topic.name} #{number}"
        end
      end

      private

      def showing_within? issue, topic
          within "[#{issue.container_attribute}]" do
            showing? topic
          end
      end

      def link_highlighted_for? topic
        within 'a.active' do
          showing? topic
        end
      end

      def at_filtered_issue_page_for? topic
        current_url.include? "topic=#{topic.id}"
      end

      def showing? topic
        has_content? topic.name
      end
    end
  end
end
