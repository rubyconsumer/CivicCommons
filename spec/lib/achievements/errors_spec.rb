require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Achievements
  describe AchievementsErrors do
    it "may be raised as an error" do
      lambda {raise Achievements::AchievementsErrors}.should raise_error(Achievements::AchievementsErrors)
    end
  end
  describe AchievementNotFoundError do
    it "may be raised as an error" do
      lambda {raise Achievements::AchievementNotFoundError}.should raise_error(Achievements::AchievementNotFoundError)
    end
  end
  describe MultipleAchievementsFoundError do
    it "may be raised as an error" do
      lambda {raise Achievements::MultipleAchievementsFoundError}.should raise_error(Achievements::MultipleAchievementsFoundError)
    end
  end
end

