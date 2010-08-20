require 'spec_helper'

describe Event do
  describe "when saving an event" do
    it "should require a name" do
      event = Event.new({:title=>"", :when=>nil, :where=>"Test Location"})
      event.save.should == false
      event.errors.count.should == 1
      event.errors[:title].should_not be_empty            
    end
    
    it "should require a location" do
      event = Event.new({:title=>"Test Event", :when=>nil, :where=>""})
      event.save.should == false
      event.errors.count.should == 1
      event.errors[:where].should_not be_empty            
    end    
  end    
end