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
      @topic = mock_model(Topic,:issue_count => 1, :name => 'Topic One')
      @current_topic = mock_model(Topic,:issue_count => 1, :name => 'Topic Two')
    end
    it "should display the correct link tag" do
      helper.issue_topic_filter(@topic).should == "<a href=\"/issues?topic=1001\" class=\"\">Topic One (1)</a>"
    end
    it "should have an 'active' class if the current topic has matched" do
      helper.issue_topic_filter(@current_topic).should == "<a href=\"/issues\" class=\"active\">Topic Two (1)</a>"
    end
    it "should not have 'active' css class if the current topic has not match" do
      helper.issue_topic_filter(@topic).should == "<a href=\"/issues?topic=1005\" class=\"\">Topic One (1)</a>"
    end
    
  end
end
