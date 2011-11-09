require 'spec_helper'

describe IssuePresenter do
  def create_presenter(topics = [])
    topics = topics.map {|t| stub(name: t)}
    IssuePresenter.new stub(topics: topics)
  end

  context 'when there are no topics' do
    it "does not display topics" do
      create_presenter.filed_under.should == ""
    end
  end

  context "when there is 1 topic" do
    it "displays just the one topic" do
      presenter = create_presenter(['cool beans'])
      presenter.filed_under.should == "cool beans"
    end
  end

  context "when there are more than one topic" do
    it "displays the topics comma seperated" do
      presenter = create_presenter(['foo', 'bar'])
      presenter.filed_under.should == "foo, bar"
    end
  end
end
