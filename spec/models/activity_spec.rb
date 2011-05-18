require 'spec_helper'

describe Activity do

  context "Validation" do

    let(:params) do
      Factory.attributes_for(:activity)
    end

    it "Requires item_id" do
      params.delete(:item_id)
      Activity.new(params).should_not be_valid
    end

    it "Requires item_type" do
      params.delete(:item_type)
      Activity.new(params).should_not be_valid
    end

    it "Requires item_created_at" do
      params.delete(:item_created_at)
      Activity.new(params).should_not be_valid
    end

    it "Validates the item exists" do
      params.delete(:item_created_at)
      Activity.new(params).should_not be_valid
    end

  end

  context "Creates new activity object from existing active record object" do

    it "Creates a new activity from valid conversation object" do
      obj = Factory.build(:conversation, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Conversation'
    end

    it "Creates a new activity from valid comment object" do
      obj = Factory.build(:comment, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Contribution'
    end

    it "Creates a new activity from valid question object" do
      obj = Factory.build(:question, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Contribution'
    end

    it "Creates a new activity from valid suggested action object" do
      obj = Factory.build(:suggested_action, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Contribution'
    end

    it "Creates a new activity from valid link object" do
      obj = Factory.build(:link, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Contribution'
    end

    it "Creates a new activity from valid answer object" do
      obj = Factory.build(:answer, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Contribution'
    end

    it "Creates a new activity from valid ebmedly object object" do
      obj = Factory.build(:embedly_contribution, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Contribution'
    end

    it "Creates a new activity from valid attached file object" do
      obj = Factory.build(:attached_file, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Contribution'
    end

    it "Creates a new activity from valid issue object" do
      obj = Factory.build(:issue, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'Issue'
    end

    it "Creates a new activity from valid rating group object" do
      obj = Factory.build(:rating_group, id: 1, created_at: Time.now)
      a = Activity.new(obj)
      a.should be_valid
      a.item_type.should == 'RatingGroup'
    end

    it "Does not create a new acivity on top level contribution" do
      obj = Factory.build(:top_level_contribution, id: 1, created_at: Time.now)
      Activity.new(obj).should_not be_valid
    end

    it "Does not create a new acivity on non supported active record type" do
      obj = Factory.build(:normal_person, id: 1, created_at: Time.now)
      Activity.new(obj).should_not be_valid
    end

  end

  context "Removing activity records" do

    let(:convo) do
      Factory.create(:conversation)
    end

    before(:each) do
      @item_count = 3
      @total_count = 12
      (1..@item_count).each do |i|
        Factory.create(:conversation_activity, item_id: convo.id)
        Factory.create(:contribution_activity, item_id: 1)
        Factory.create(:issue_activity, item_id: 1)
        Factory.create(:rating_group_activity, item_id: 1)
      end
    end

    it "removes all activity records when one or more are found" do
      Activity.all.count.should == @total_count
      Activity.delete(convo)
      Activity.all.count.should == @total_count - @item_count
    end

    it "removed no activity objects when none are found" do
      Activity.all.count.should == @total_count
      Activity.destroy(convo)
      Activity.all.count.should == @total_count - @item_count
    end

    it "calls #delete_all for Acticity#delete" do
      Activity.should_receive(:delete_all).once
      Activity.delete(convo)
    end

    it "calls #destriy_all for Activity#destroy" do
      Activity.should_receive(:destroy_all).once
      Activity.destroy(convo)
    end

  end

end
