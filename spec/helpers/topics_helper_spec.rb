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
    before(:each) do
      @topic = mock(Topic,:issue_count => 1, :name => 'Topic One', :id => 1001)
      @current_topic = mock(Topic,:issue_count => 1, :name => 'Topic Two', :id => 1002)
    end
    it "should link to the topic" do
      issue_topic_filter(@topic).should include 'href="/issues?topic=1001"'
      issue_topic_filter(@topic).should include 'Topic One'
    end
    it "should have an 'active' class if the current topic has matched" do
      issue_topic_filter(@current_topic).should include 'class="active"'
    end
    it "should not have 'active' css class if the current topic has not match" do
      issue_topic_filter(@topic).should_not include "active"
    end
  end
end
