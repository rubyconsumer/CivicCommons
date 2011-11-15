require 'spec_helper'

describe IssuesHelper do

  def build_topics(topics = [])
    topics = topics.each_with_index.map {|t, k| stub(name: t, id: k + 1)}
    stub(topics: topics)
  end

  context 'when there are no topics' do
    it "does not display topics" do
      topics_list_for(build_topics).should eq ""
    end
  end

  context "when there is 1 topic" do
    let(:issue) { build_topics ['cool beans'] }
    it "displays just the one topic" do
      topics_list_for(issue).should include "cool beans"
    end
    it "makes that topic a link" do
      topics_list_for(issue).should include '<a href="/issues?topic=1">cool beans</a>'
    end
    it "encapsulates the link in the span with the data-topic-id" do
      topics_list_for(issue).should include 'data-topic-id="1"'
    end
  end

  context "when there are more than one topic" do
    it "displays the topics comma seperated" do
      raw_text = strip_tags(topics_list_for(build_topics(['foo', 'bar'])))
      raw_text.squeeze(" ").should include "foo, bar"
    end
  end
end
