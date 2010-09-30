require 'spec_helper'

describe Contribution do
  describe "when creating a contribution for a conversation" do
    before(:each) do
      @conversation = Factory.create(:conversation)
      @mock_person = Factory.create(:normal_person)      
    end
    context "and contribution does not belong to another contribution" do
      it "should return an error if it is not a top level contribution" do
        contribution = Comment.create({:person=>@mock_person, :content => "Hello World"})
        contribution.errors.count.should_not == 0
      end
    end
    context "and there is a validation error with the contribution" do
      it "should return a contribution with an error" do
        contribution = Contribution.create({:person=>@mock_person, :content=>nil})
        contribution.errors.count.should_not == 0
      end
    end
    context "and the contribution saves successfully" do
      it "should add the contribution to a conversation" do
        contribution = TopLevelContribution.create({:conversation=>@conversation, :person=>@mock_person, :content=>"Hello World"})
        @conversation.contributions.count.should == 1
        @conversation.contributions[0].should == contribution
      end
      it "should return a contribution with no errors" do
        contribution = TopLevelContribution.create({:conversation=>@conversation, :person=>@mock_person, :content=>"Hello World"})
        contribution.errors.count.should == 0
      end  
      it "should set the passed in user as the owner" do
        contribution = Contribution.create({:conversation=>@conversation, :person=>@mock_person, :content=>"Hello World"})
        contribution.person.should == @mock_person
      end    
      it "should set the item to the conversation" do 
        contribution = Contribution.create({:conversation=>@conversation, :person=>@mock_person, :content=>"Hello World"})
        contribution.item.should == @conversation
      end
    end
  end
  describe "when creating a contribution for an issue" do
    before(:each) do
      @issue = Factory.create(:issue)
      @mock_person = Factory.create(:normal_person)      
    end
    it "should set the item to the issue" do 
      contribution = Contribution.create({:issue=>@issue, :person=>@mock_person, :content=>"Hello World"})
      contribution.item.should == @issue
    end
  end
end
