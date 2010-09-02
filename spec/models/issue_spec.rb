require 'spec_helper'

describe Issue do
  describe "when adding an issue to a conversation" do
    context "and the issue saves successfully" do
      #TODO: Create a good method for connecting existing issues with conversations or creating new issues if needed
      #it "should add the issue to a conversation" do
      #  issue = Issue.create({:description=>"Testing"})
      #  conversation = Factory.create(:conversation)
      #  Conversation.stub(:find).with(1).and_return(conversation)
      #  issue = Issue.add_to_conversation(issue, conversation)
      #  conversation.issues.count.should == 1
      #end
      #it "should return an issue with no errors" do
      #  issue = Issue.create({:description=>"Testing"})
      #  conversation = Factory.create(:conversation)
      #  Conversation.stub(:find).with(1).and_return(conversation)
      #  issue = Issue.add_to_conversation(issue, conversation)
      #  issue.errors.count.should == 0
      #end      
    end
  end  
end