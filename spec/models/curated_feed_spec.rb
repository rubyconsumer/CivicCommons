require 'spec_helper'

describe CuratedFeed do

  let(:params) do
    Factory.attributes_for(:curated_feed)
  end

  context "validation" do

    it "creates a valid object" do
      CuratedFeed.new(params).should be_valid
    end

    it "validates presence of title" do
      params.delete(:title)
      CuratedFeed.new(params).should_not be_valid
    end

    it "validates uniqueness of title" do
      feed = Factory.create(:curated_feed)
      params[:title] = feed.title
      CuratedFeed.new(params).should_not be_valid
    end

  end

end
