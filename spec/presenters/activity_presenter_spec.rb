require 'spec_helper'

describe ActivityPresenter do

  before(:all) do
   ActiveRecord::Observer.enable_observers 
   # let the observer create the activity
   @user = Factory.create(:admin_person)
   @convo = Factory.create(:conversation, owner: @user)
   (1..3).each { |i| Factory.create(:contribution, conversation: @convo) }
   @activity = Activity.all
   @presenter = ActivityPresenter.new(@activity)
  end

  after(:all) do
   ActiveRecord::Observer.disable_observers 
   DatabaseCleaner.clean
  end

  context "creation" do

    it "requires a collection of objects" do
      lambda { ActivityPresenter.new }.should raise_error
      lambda { ActivityPresenter.new(@activity) }.should_not raise_error
    end

    it "does not change the order of the collection" do
      @activity.each_with_index do |item, index|
        item.item_id.should == @presenter[index].id
      end
    end

  end

  context "enumeration" do

    it "iterates over the entire set of activity items" do
      count = 0
      @presenter.each { |item| count += 1 }
      count.should == @presenter.size
    end

    it "returns the real item (not the activity record)" do
      @presenter.each do |item|
        Activity.valid_type?(item).should be_true
      end
    end

    it "returns the correct type when calling #each_with_type" do
      index = 0
      @presenter.each_with_type do |item, type|
        type.should == @activity[index].item_type
        index += 1
      end
    end

  end

  context "retrieval" do

    context "#at" do

      it "retrieves the item at the requested index" do
        index = (@activity.size / 2).to_i
        @presenter.at(index).id.should == @activity[index].item_id
      end

      it "supports negative indexes" do
        index = -1
        @presenter.at(index).id.should == @activity[index].item_id
      end

      it "returns nil when given an invalid index" do
        index = @activity.size + 1
        @presenter.at(index).should be_nil
      end

    end

    context "[]" do

      it "retrieves the item at the requested index" do
        index = (@activity.size / 2).to_i
        @presenter[index].id.should == @activity[index].item_id
      end

      it "supports negative indexes" do
        index = -1
        @presenter[index].id.should == @activity[index].item_id
      end

      it "returns nil when given an invalid index" do
        index = @activity.size + 1
        @presenter[index].should be_nil
      end

    end

    context "descriptors" do

      context "empty?"

      it "returns true for an empty collection" do
        ActivityPresenter.new([]).should be_empty
      end

      it "returns false for a collection with elements" do
        @presenter.should_not be_empty
      end

    end

    context "size" do

      it "returns zero for an empty collection" do
        ActivityPresenter.new([]).size.should == 0
      end

      it "returns the correct count for a collection with elements" do
        @presenter.size.should == @activity.size
      end

    end

  end

  context "accessors" do

    context "#first" do

      it "returns the first object for a collection with elements" do
        @presenter.first.id.should == @activity.first.item_id
      end

      it "retrns nil for an empty collection" do
        ActivityPresenter.new([]).first.should be_nil
      end

    end

    context "#last" do

      it "returns the last object for a collection with elements" do
        @presenter.last.id.should == @activity.last.item_id
      end

      it "retrns nil for an empty collection" do
        ActivityPresenter.new([]).last.should be_nil
      end

    end

    context "#type_at" do

      it "returns the type (as string) of the object for a collection with elements" do
        @presenter.type_at(0).should be_instance_of String
        @presenter.type_at(0).should == @activity[0].item_type
      end

      it "retrns nil for an empty collection" do
        ActivityPresenter.new([]).type_at(0).should be_nil
      end

    end

  end

end
