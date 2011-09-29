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
  
  def given_a_user_have_voted
    @person = Factory.create(:registered_user)
    @survey = Factory.create(:vote)
    @survey_option1 = Factory.create(:survey_option,:survey_id => @survey.id, :position => 1)
    @presenter = VoteResponsePresenter.new(:person_id => @person.id,
      :survey_id => @survey.id, 
      :selected_option_1_id => 11, 
      :selected_option_2_id => 22)
    @presenter.save
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
    
    it "creates a new activity record when someone have voted(A survey_response has been created)" do
      given_a_user_have_voted
      a = Activity.last
      a.item_id.should == @presenter.id
      a.item_type.should == 'SurveyResponse'
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

    it 'does not create a contribution activity record when contribution is part of conversation creation' do
      contribution = Factory.create(:top_level_contribution)
      Activity.where(item_id: contribution.id, item_type: "Contribution").should be_empty
    end

    it 'creates a new activity record when a contribution is added to an existing comversation' do
      conversation = Factory.create(:user_generated_conversation)
      contribution = Factory.create(:contribution_without_parent, conversation: conversation)
      a = Activity.last
      a.item_id.should == contribution.id
      a.item_type.should == 'Contribution'
    end

    it 'does not create a new activity record for contributions on preview' do
      conversation = Factory.create(:conversation)
      contribution = Factory.create(:unconfirmed_contribution, id: 5, conversation: conversation)
      a = Activity.last
      a.item_id.should_not == contribution.id
      a.item_type.should_not == 'Contribution'
    end

    it 'does not create a new activity record on update for contribution' do
      conversation = Factory.create(:conversation)
      top_level_contribution = Factory.create(:top_level_contribution, conversation: conversation)
      contribution = Factory.create(:comment, conversation: conversation, parent: top_level_contribution)
      contribution.update_attributes(content: "changed my mind...")
      a = Activity.where(item_id: contribution.id, item_type: 'Contribution')
      a.size.should == 1
    end

  end

  context "when destroying" do
    context 'a conversation' do
      it 'removes activity records when a conversation is deleted/destroyed' do
        conversation = Factory.create(:conversation)
        Activity.where(item_id: conversation.id, item_type: 'Conversation').should_not be_empty
        Conversation.destroy(conversation)
        Activity.where(item_id: conversation.id, item_type: 'Conversation').should be_empty
      end
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
    
    it "removes the actvity records when a survey_response is destroyed" do
      given_a_user_have_voted
      Activity.where(item_id: @presenter.id, item_type: 'SurveyResponse').should_not be_empty
      @presenter.survey_response.destroy
      Activity.where(item_id: @presenter.id, item_type: 'SurveyResponse').should be_empty
    end

  end
end
