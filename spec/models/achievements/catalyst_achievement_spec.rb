require 'spec_helper'

describe CatalystAchievement do
  before (:each) do
    Factory.create(:achievement_metadata_bronze, :title => 'Catalyst')
  end

  it "observers Conversations" do
    CatalystAchievement.observers?.should == :Conversation
  end

  it "has_award? returns false when the user has not created a conversation already" do
    CatalystAchievement.has_award?(Factory.create(:conversation)).should be_false
  end

  it "has_award? returns true when the user has created a conversation already" do
    c = Factory.create(:conversation)
    p = c.owner
    md = CatalystAchievement.achievement_metadata
    earned = Factory.create(:achievement_earned, :person_id => p, :achievement_metadata_id => md.id)

    CatalystAchievement.has_award?(c).should be_true
  end

  it "awards? displays user who gets an achievement" do
    c = Factory.create(:conversation)
    p = c.owner
    md = CatalystAchievement.achievement_metadata
    #earned = Factory.create(:achievement_earned, :person_id => p, :achievement_metadata_id => md.id)

    CatalystAchievement.awards?(c).should == {md.id => [p]}
  end


end

