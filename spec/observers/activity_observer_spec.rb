require 'spec_helper'

describe ActivityObserver do

  before :all do
    ActiveRecord::Observer.enable_observers
  end

  after :all do
    ActiveRecord::Observer.disable_observers
  end

  before :each do
    AvatarService.stub(:update_person).and_return(true)
  end

  context "On create" do

    it 'creates a new activity record when a conversation is created' do
      conversation = Factory.create(:conversation)
      a = Activity.last
      a.item_id.should == conversation.id
      a.item_type.should == 'Conversation'
      a.activity_cache.should_not be_nil
    end

    it 'creates a new activity record when a rating group is created' do
      rating_group = Factory.create(:rating_group)
      a = Activity.last
      a.item_id.should == rating_group.id
      a.item_type.should == 'RatingGroup'
      a.activity_cache.should_not be_nil
    end

  end

  context "after saving" do

    it 'creates a new activity record when a contribution is confirmed' do
      conversation = Factory.create(:conversation)
      contribution = Factory.create(:contribution, :conversation => conversation)
      contribution = Factory.create(:contribution, :conversation => conversation)
      a = Activity.where(item_type: 'Contribution', item_id: contribution.id).first
      a.item_id.should == contribution.id
      a.item_type.should == 'Contribution'
      a.activity_cache.should_not be_nil
    end

    it 'does not create a contribution activity record when contribution is part of conversation creation'
    it 'creates a new activity record when a contribution is added to an existing comversation'
    it 'does not create a new activity record for contributions on preview'
    it 'does not create a new activity record on update for contribution'

  end

  context "On destroy" do

    it 'removes activity records when a conversation is deleted/destroyed' do
      conversation = Factory.create(:conversation)
      Conversation.destroy(conversation)
      Activity.where(item_id: conversation.id, item_type: 'Conversation').should be_empty
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
