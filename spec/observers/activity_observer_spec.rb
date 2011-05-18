require 'spec_helper'

describe ActivityObserver do

  before :all do
    ActiveRecord::Observer.enable_observers
  end

  after :all do
    ActiveRecord::Observer.disable_observers
  end

  context "On create" do
    it 'creates a new activity record when a conversation is created' do
      conversation = Factory.create(:conversation)
      a = Activity.last
      a.item_id.should == conversation.id
      a.item_type.should == 'Conversation'
    end

    it 'creates a new activity record when a issue is created' do
      issue = Factory.create(:issue)
      a = Activity.last
      a.item_id.should == issue.id
      a.item_type.should == 'Issue'
    end

    it 'creates a new activity record when a rating group is created' do
      rating_group = Factory.create(:rating_group)
      a = Activity.last
      a.item_id.should == rating_group.id
      a.item_type.should == 'RatingGroup'
    end

  end

  context "after saving" do

    it 'creates a new activity record when a contribution is confirmed' do
      contribution = Factory.create(:contribution)
      a = Activity.last
      a.item_id.should == contribution.id
      a.item_type.should == 'Contribution'
    end

    it 'does not create a new activity record for contributions on preview'
    it 'does not create a new activity record on update for contribution'

  end

  context "On destroy" do

    it 'removes activity records when a conversation is deleted/destroyed' do
      conversation = Factory.create(:conversation)
      Conversation.destroy(conversation)
      Activity.where(item_id: conversation.id, item_type: 'Conversation').should be_empty
    end

    it 'removes activity records when an issue is deleted/destroyed' do
      issue = Factory.create(:issue)
      Issue.destroy(issue)
      Activity.where(item_id: issue.id, item_type: 'Issue').should be_empty
    end

    it 'removes activity records when a contribution is deleted/destroyed' do
      contribution = Factory.create(:contribution)
      Contribution.destroy(contribution)
      Activity.where(item_id: contribution.id, item_type: 'Contribution').should be_empty
    end

    it 'removes activity records when a rating group is deleted/destroyed' do
      rating_group = Factory.create(:rating_group)
      RatingGroup.destroy(rating_group)
      Activity.where(item_id: rating_group.id, item_type: 'RatingGroup').should be_empty
    end

  end

end
