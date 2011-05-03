require 'spec_helper'

describe ContentItem do

  before(:all) do
    @author = Factory.build(:admin_person)
  end

  before(:each) do
    @attr = Factory.attributes_for(:content_item)
    @attr[:author] = @author
  end

  context "validations" do

    it "creates a valid object" do
      ContentItem.new(@attr).should be_valid
    end

    it "validates the presence of title" do
      @attr.delete(:title)
      ContentItem.new(@attr).should_not be_valid
    end

    it "validates the presence of body" do
      @attr.delete(:body)
      ContentItem.new(@attr).should_not be_valid
    end

    it "validates the presence of published" do
      @attr.delete(:published)
      ContentItem.new(@attr).should_not be_valid
    end

    it "validates the presence of author" do
      @attr.delete(:author)
      ContentItem.new(@attr).should_not be_valid
    end

    it "validates the uniqueness of the title" do
      ContentItem.new(@attr).save
      ContentItem.new(@attr).should_not be_valid
    end

    it "validates the presence of an external link for a news item" do
      @attr[:content_type] = 'NewsItem'
      @attr.delete(:external_link)
      ContentItem.new(@attr).should_not be_valid
    end

    it "validates the presence of an embed code for a radio show" do
      @attr[:content_type] = 'RadioShow'
      @attr.delete(:embed_code)
      ContentItem.new(@attr).should_not be_valid
    end

  end

end
