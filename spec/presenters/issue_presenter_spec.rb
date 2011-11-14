require 'spec_helper'

describe IssuePresenter do
  def create_presenter(topics = [])
    topics = topics.each_with_index.map {|t, k| stub(name: t, id: k + 1)}
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
      presenter.filed_under.should match "cool beans"
    end
    it "makes that topic a link" do
      presenter = create_presenter(['asdf'])
      presenter.filed_under.should include "<a href='/issues/?topic=1'>asdf</a>"
    end
    it "encapsulates the link in the span" do
      presenter = create_presenter(['asdf'])
      presenter.filed_under.should match "data-topic-id='1'"
    end
  end

  context "when there are more than one topic" do
    it "displays the topics comma seperated" do
      presenter = create_presenter(['foo', 'bar'])
      presenter.filed_under.should match "foo"
      presenter.filed_under.should match ", "
      presenter.filed_under.should match "bar"
    end
  end

end
