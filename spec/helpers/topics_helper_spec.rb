require 'spec_helper'

describe TopicsHelper do
  describe "render_issue_topics_sidebar" do
    it "should render the topic/issue_topic_sidebar" do
      @topics = 'topic-id'
      helper.should_receive(:render).with('topics/issue_topic_sidebar', :topics =>'topic-id')
      helper.render_issue_topics_sidebar#.with().render_issue_topics_sidebar.should_render_template 'render_issue_topics_sidebar'
    end
  end
  describe "issue_topic_filter" do

    context "with a topic that is not selected" do
      let :topic { mock(Topic,:issue_count => 1, :name => 'Topic One', :id => 1001) }
      let :topic_filter_element {  helper.issue_topic_filter(topic) }

      it "should link to topic 1001" do
        topic_filter_element.should include "/issues?topic=1001"
        topic_filter_element.should include topic.name
      end

      it "should not be highlighted" do
        topic_filter_element.should_not include 'class="active"'
      end
    end
    context "with a selected topic" do
      let :currently_selected_topic =  { mock(Topic,:issue_count => 1, :name => 'Topic Two', :id => 1002) }
      let :topic_filter_element {  helper.issue_topic_filter(currently_selected_topic) }

      it "should have an 'active' class" do
        topic_filter_element.should include 'class="active"'
      end
    end
  end
end
