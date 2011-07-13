require 'spec_helper'

describe CCML::Tag::CuratedFeedTag do

  context "#index method" do

    before(:each) do
      @curated_feed = Factory.create(:curated_feed)
      @url = "http://www.theciviccommons.com/feeds/#{@curated_feed.cached_slug}"
      @tag_body = '{id} "{title}" {cached_slug}'
      @tag_regexp = Regexp.new("#{@curated_feed.id} \"#{@curated_feed.title}\" #{@curated_feed.cached_slug}")
    end

    it "accepts an id as opts id" do
      tag = CCML::Tag::CuratedFeedTag.new({id: @curated_feed.id}, @url)
      tag.tag_body = @tag_body
      tag.index.should =~ @tag_regexp
    end

    it "accepts a cached_slug as opts id" do
      tag = CCML::Tag::CuratedFeedTag.new({id: @curated_feed.cached_slug}, @url)
      tag.tag_body = @tag_body
      tag.index.should =~ @tag_regexp
    end

    it "gets the id from segment 1 if no id is given" do
      tag = CCML::Tag::CuratedFeedTag.new({}, @url)
      tag.tag_body = @tag_body
      tag.index.should =~ @tag_regexp
    end

    it "returns blank if the requested curated_feed is not found" do
      tag = CCML::Tag::CuratedFeedTag.new({id: 0}, @url)
      tag.tag_body = @tag_body
      tag.index.should be_blank
    end

  end

  context "#all method" do

    before(:each) do
      @tag_body = '{id} "{title}" {cached_slug}'
    end

    it "returns all curated feeds" do
      feeds = []
      3.times {|i| feeds << Factory.create(:curated_feed) }
      tag = CCML::Tag::CuratedFeedTag.new({})
      tag.tag_body = @tag_body
      output = tag.all
      feeds.each do |feed|
        output.should =~ /#{feed.id} \"#{feed.title}\" #{feed.cached_slug}/
      end
    end

    it "returns blank when no curated feeds exist" do
      tag = CCML::Tag::CuratedFeedTag.new({})
      tag.tag_body = @tag_body
      tag.all.should be_blank
    end

  end

  context "#items method" do

    before(:each) do
      @feed = Factory.create(:curated_feed)
      @tag_body = '{id} "{title}" {original_url}'
    end

    it "returns all items associated with a feed" do
      3.times {|i| Factory.create(:curated_feed_item, curated_feed: @feed) }
      tag = CCML::Tag::CuratedFeedTag.new({id: @feed.id})
      tag.tag_body = @tag_body
      output = tag.items
      items = CuratedFeed.includes(:curated_feed_items).find(@feed.id).curated_feed_items
      items.each do |item|
        output.should =~ /#{item.id} \"#{item.title}\" #{item.original_url}/
      end
    end

    it "returns blank if the feed is not found" do
      tag = CCML::Tag::CuratedFeedTag.new({})
      tag.tag_body = @tag_body
      tag.items.should be_blank
    end

    it "returns blank if the feed has no items" do
      tag = CCML::Tag::CuratedFeedTag.new({id: @feed.id})
      tag.tag_body = @tag_body
      tag.items.should be_blank
    end

  end

end
