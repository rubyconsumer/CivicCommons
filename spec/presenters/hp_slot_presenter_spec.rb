require 'spec_helper'

default_url_options[:host] = "test.host"

describe HPSlotPresenter do

  # before(:all) do
  #  ActiveRecord::Observer.enable_observers
  # end

  context "creation" do
    it "requires an object" do
      lambda { HPSlotPresenter.new }.should raise_error
      lambda { HPSlotPresenter.new(nil) }.should_not raise_error
    end
  end

  context "title" do
    it "is available with an Issue object" do
      i = Factory.create(:issue, :name => "Some Issue Name")
      hsp = HPSlotPresenter.new(i)
      hsp.title.should == "Some Issue Name"
    end

    it "is available with a Conversation object" do
      i = Factory.create(:conversation, :title => "Some Conversation Title")
      hsp = HPSlotPresenter.new(i)
      hsp.title.should == "Some Conversation Title"
    end

    it "is available with a HomepageFeatured object" do
      i = Factory.create(:homepage_featured)
      hsp = HPSlotPresenter.new(i)
      hsp.title.should == "Homepage Featurable Title"
    end

    it "is nil with a Contribution object" do
      i = Factory.create(:contribution)
      hsp = HPSlotPresenter.new(i)
      hsp.title.should == nil
    end

    it "is nil with a nil object" do
      hsp = HPSlotPresenter.new(nil)
      hsp.title.should == nil
    end
  end

  context "url" do
    it "is available for an Issue object" do
      i = Factory.create(:issue, :name => "Some Issue Name")
      hsp = HPSlotPresenter.new(i)

      # hsp.url.should == "http://www.example.com/issues/#{i.friendly_id}"
      hsp.url.should == "/issues/#{i.friendly_id}"
    end

    it "is available with a Conversation object" do
      i = Factory.create(:conversation, :title => "Some Conversation Title")
      hsp = HPSlotPresenter.new(i)

      # hsp.url.should == "http://www.example.com/conversations/#{i.friendly_id}"
      hsp.url.should == "/conversations/#{i.friendly_id}"
    end

    it "is host url with a Contribution object" do
      i = Factory.create(:contribution)
      hsp = HPSlotPresenter.new(i)
      hsp.url.should == "/"
    end
  end

end
