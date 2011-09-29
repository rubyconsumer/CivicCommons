require 'spec_helper'

default_url_options[:host] = "test.host"

describe HPSlotPresenter do

  # before(:all) do
  #  ActiveRecord::Observer.enable_observers
  # end

  describe "creation" do
    it "requires an object" do
      lambda { HPSlotPresenter.new }.should raise_error
      lambda { HPSlotPresenter.new(nil) }.should_not raise_error
    end
  end

  describe "title" do
    it "is available with an Issue object" do
      issue = Factory.create(:issue, :name => "Some Issue Name")
      hsp = HPSlotPresenter.new(issue)
      hsp.title.should == "Some Issue Name"
    end

    it "is available with a Conversation object" do
      conversation = Factory.create(:conversation, :title => "Some Conversation Title")
      hsp = HPSlotPresenter.new(conversation)
      hsp.title.should == "Some Conversation Title"
    end

    it "is available with a HomepageFeatured object" do
      hp_feature = Factory.create(:homepage_featured)
      hsp = HPSlotPresenter.new(hp_feature)
      hsp.title.should == "Homepage Featurable Title"
    end

    it "is nil with a Contribution object" do
      contribution = Factory.create(:contribution)
      hsp = HPSlotPresenter.new(contribution)
      hsp.title.should == nil
    end

    it "is nil with a nil object" do
      hsp = HPSlotPresenter.new(nil)
      hsp.title.should == nil
    end
  end

  describe "url" do
    it "is available for an Issue object" do
      issue = Factory.create(:issue, :name => "Some Issue Name")
      hsp = HPSlotPresenter.new(issue)

      # hsp.url.should == "http://www.example.com/issues/#{i.friendly_id}"
      hsp.url.should == "/issues/#{issue.friendly_id}"
    end

    it "is available with a Conversation object" do
      conversation = Factory.create(:conversation, :title => "Some Conversation Title")
      hsp = HPSlotPresenter.new(conversation)

      # hsp.url.should == "http://www.example.com/conversations/#{i.friendly_id}"
      hsp.url.should == "/conversations/#{conversation.friendly_id}"
    end

    it "is host url with a Contribution object" do
      contribution = Factory.create(:contribution)
      hsp = HPSlotPresenter.new(contribution)
      hsp.url.should == "/"
    end
  end

  describe "image" do
    it "returns an image url" do
      object_with_image = Object
      object_with_image.stub!(:respond_to?).and_return(true)
      object_with_image.stub!(:image).and_return("http://some-url.to/some_image.png")

      hsp = HPSlotPresenter.new(object_with_image)
      hsp.image.should == "http://some-url.to/some_image.png"
    end

    it "with different sizes returns the normal image" do
      image_object = Object
      image_object.stub!(:respond_to?).with(:url).and_return(true)
      image_object.stub!(:url).with(:normal).and_return("http://some-url.to/some_image_normal.png")

      object_with_image = Object
      object_with_image.stub!(:respond_to?).and_return(true)
      object_with_image.stub!(:image).and_return(image_object)

      hsp = HPSlotPresenter.new(object_with_image)
      hsp.image.should == "http://some-url.to/some_image_normal.png"
    end
  end

end
