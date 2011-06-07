require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Achievements
  describe Directory do
    it "returns an empty array when a model is not present" do
      Directory.lookup_by_model(:something_random).should == []
    end

    it "adds and looks up a basic entry to the directory" do
      Directory.lookup_by_model(:some_model).should == []
      Directory.add_achievement(:some_achievement, :some_model)
      Directory.lookup_by_model(:some_model).should == [:some_achievement]
    end

    it "adds and looks up a targeted (create/update/etc) entry to the directory" do
      Directory.lookup_by_model(:some_other_model).should == []
      Directory.add_achievement(:some_achievement, :some_other_model, :create)
      Directory.lookup_by_model(:some_other_model).should == []
      Directory.lookup_by_model(:some_other_model, :create).should == [:some_achievement]
    end

    it "with default and create entries for a model should bring up both when querying the default type" do
      Directory.lookup_by_model(:this_model).should == []
      Directory.add_achievement(:default_achievement, :this_model)
      Directory.add_achievement(:create_achievement, :this_model, :create)
      Directory.lookup_by_model(:this_model).should == [:default_achievement]
      Directory.lookup_by_model(:this_model, :create).should == [:create_achievement, :default_achievement]
    end
  end
end

