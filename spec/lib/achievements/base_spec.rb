require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")


class TestAchievement < Achievements::Base
end

module Achievements
  describe Base do
    it "will error when expiration date is not over ridden" do
      lambda{ TestAchievement.expiration_date }.should raise_error(NotImplementedError)
    end

    it "will error when skip rake is not over ridden" do
      lambda{ TestAchievement.skip_rake? }.should raise_error(NotImplementedError)
    end

    it "will error when earn badge is not over ridden" do
      lambda{ TestAchievement.earn_badge?(nil) }.should raise_error(NotImplementedError)
    end

    it "will error when awards is not over ridden" do
      lambda{ TestAchievement.awards? }.should raise_error(NotImplementedError)
    end

  end
end

