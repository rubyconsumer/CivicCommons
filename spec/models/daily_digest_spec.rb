require 'spec_helper'

describe DailyDigest do

  before(:each) do
    @john = Factory.create(:normal_person, daily_digest: true, name: "John Doe")
    @jane = Factory.create(:normal_person, daily_digest: false, name: "Jane Doe")
    @digest = DailyDigest.new
  end

  describe "On creation" do

    it "prepares a list of all people that have not opted-out of the digest" do
      @digest.mailing_list.length.should == 1
      @digest.mailing_list.first.should == @john
    end

  end

  describe "DailyDigest#retrieve_contributions(person)" do
    
    before(:each) do
      @conversation = Conversation.create(title: "New Conversation")
      Subscription.create(person: @john, subscribable: @conversation)
      @top_level_contribution = TopLevelContribution.create(content: "Top Level Contribution")
      @conversation.contributions << @top_level_contribution
    end
    
    it "should not include top level contributions" do
      contributions = @digest.retrieve_contributions(@john)
      contributions.should_not include(@top_level_contribution)
    end
    
  end
    

end
