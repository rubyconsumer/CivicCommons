require 'spec_helper'

describe CuratedFeedItem do

  let(:params) do
    Factory.attributes_for(:curated_feed_item)
  end

  context "validation" do

    it "creates a valid object" do
      CuratedFeedItem.new(params).should be_valid
    end

    it "validates presence of url" do
      params.delete(:url)
      CuratedFeedItem.new(params).should_not be_valid
    end

  end

  context "on save" do

    it "does not call Embedly if objectify is set" do
      pending
    end

    it "calls Embedly when objectify is blank" do
      pending
    end

    it "sets the pub_date to now when pub_date is blank" do
      pending
    end

  end

  context "#update_objectify" do

  end

  context "#reset" do

  end

  context "#struct" do

  end

end
