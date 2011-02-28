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
      @top_level_contribution = Factory.create(:top_level_contribution, conversation: @conversation, created_at: Time.now - 1.day)
      @top_level_contribution.run_callbacks(:save)
      @comment = Factory.create(:comment, { conversation: @conversation, parent: @top_level_contribution, person: @jane, created_at: Time.now - 1.day })

      @issue = Issue.create(name: "New Issue")
      Subscription.create(person: @john, subscribable: @issue)
      @issue_comment = Factory.create(:comment, { issue: @issue, parent: nil, person: @jane, created_at: Time.now - 1.day })
      @issue_comment.run_callbacks(:save)
    end

    it "does not include top level contributions" do
      contributions = @digest.retrieve_contributions(@john)
      contributions.should_not include(@top_level_contribution)
    end

    it "does not include contributions tied to issues" do
      contributions = @digest.retrieve_contributions(@john)
      contributions.should_not include(@issue_comment)
    end

    it "includes comments" do
      comment = Factory.create(:comment, { conversation: @conversation, parent: @top_level_contribution, person: @jane, created_at: Time.now - 1.day })
      comment.run_callbacks(:save)
      contributions = @digest.retrieve_contributions(@john)
      contributions.should include(comment)
      contributions.length.should == 2
    end
    
    it "includes nested comments" do
      comment = Factory.create(:comment, { conversation: @conversation, parent: @comment, person: @jane, created_at: Time.now - 1.day })
      comment.run_callbacks(:save)
      contributions = @digest.retrieve_contributions(@john)
      contributions.should include(comment)
      contributions.should include(@comment)
      contributions.length.should == 2
    end
    
    it "includes comments made after yesterday at midnight" do
      comment = Factory.create(:comment, { conversation: @conversation, parent: @comment, person: @jane, created_at: Time.now.midnight - 1.day + 1.minute })
      comment.run_callbacks(:save)
      contributions = @digest.retrieve_contributions(@john)
      contributions.should include(comment)
      contributions.should include(@comment)
      contributions.length.should == 2
    end
    
    it "includes comments made yesterday at midnight" do
      comment = Factory.create(:comment, { conversation: @conversation, parent: @comment, person: @jane, created_at: Time.now.midnight - 1.day })
      comment.run_callbacks(:save)
      contributions = @digest.retrieve_contributions(@john)
      contributions.should include(comment)
      contributions.should include(@comment)
      contributions.length.should == 2
    end
    
    it "does not includes comments made at midnight today" do
      comment = Factory.create(:comment, { conversation: @conversation, parent: @comment, person: @jane, created_at: Time.now.midnight })
      comment.run_callbacks(:save)
      contributions = @digest.retrieve_contributions(@john)
      contributions.should_not include(comment)
      contributions.should include(@comment)
      contributions.length.should == 1
    end
    
    it "does not include comments made earlier than yesterday at midnight" do
      comment = Factory.create(:comment, { conversation: @conversation, parent: @comment, person: @jane, created_at: Time.now.midnight - 1.day - 1.minute })
      comment.run_callbacks(:save)
      contributions = @digest.retrieve_contributions(@john)
      contributions.should_not include(comment)
      contributions.should include(@comment)
      contributions.length.should == 1
    end

  end


end
