require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SurveysHelper. For example:
#
# describe SurveysHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe SurveysHelper do
  describe "relative_weighted_votes_percentage" do
    it "should correctly calculate the relative wighted votes percentage" do
      helper.relative_weighted_votes_percentage(5,10).should == 50
    end
    it "should allow offsetting" do
      helper.relative_weighted_votes_percentage(5,10,-10).should == 40
      helper.relative_weighted_votes_percentage(5,10,10).should == 60
    end
    it "should not offset if it results in negative" do
      helper.relative_weighted_votes_percentage(5,10,-60).should == 50
    end
  end
end
