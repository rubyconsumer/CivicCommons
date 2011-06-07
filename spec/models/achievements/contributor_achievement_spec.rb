require 'spec_helper'

describe ContributorAchievement do
  before (:each) do
    AchievementMetadata.stub!(:find).with(1).and_return(Factory.create(:achievement_metadata_bronze))
    AchievementMetadata.stub!(:find).with(2).and_return(Factory.create(:achievement_metadata_silver))
    AchievementMetadata.stub!(:find).with(3).and_return(Factory.create(:achievement_metadata_gold))
  end

  it "validates achievement threshold is numeric" do
    c = ContributorAchievement

    c.observers?.should == :Contribution
  end

  it "gets the thresholds for all the sub-achievements" do
    ContributorAchievement.get_thresholds.should == [1, 10, 50]
  end

  it "checks if any of the thresholds are blank" do
    ContributorAchievement.blank_threshold?.should be_false
  end

  it "checks if any of the thresholds are not numeric" do
    ContributorAchievement.numeric_threshold?.should be_true
  end

  it "checks to see if thresholds are valid" do
    ContributorAchievement.valid_threshold?.should be_true
  end

  it "should pick up new thresholds values" do
    ContributorAchievement.get_thresholds.should == [1, 10, 50]
    AchievementMetadata.should_receive(:find).with(1).and_return(Factory.create(:achievement_metadata_t3))
    AchievementMetadata.should_receive(:find).with(2).and_return(Factory.create(:achievement_metadata_silver))
    AchievementMetadata.should_receive(:find).with(3).and_return(Factory.create(:achievement_metadata_gold))
    ContributorAchievement.refresh_threshold!
    ContributorAchievement.get_thresholds.should == [3, 10, 50]
  end

  it "format awards results will format results by achievment and list people who get the achievement" do
    AchievementMetadata.should_receive(:find).with(1).and_return(Factory.create(:achievement_metadata_bronze))
    AchievementMetadata.should_receive(:find).with(2).and_return(Factory.create(:achievement_metadata_silver))
    AchievementMetadata.should_receive(:find).with(3).and_return(Factory.create(:achievement_metadata_gold))
    ContributorAchievement.refresh_threshold!
    a, b, c = ContributorAchievement.get_metadata_ids

    contribution_counts = {6=>9, 7=>84, 9=>228, 10=>91, 11=>25, 12=>9, 14=>12, 15=>13, 16=>2, 17=>1}
    ContributorAchievement.format_awards_results(contribution_counts).should == {a => [6, 12, 16, 17], b => [11, 14, 15], c => [7, 9, 10]}
  end

end

