require 'spec_helper'

describe Contribution do
  describe "when creating a contribution for a conversation" do
    before(:each) do
      @mock_person = Factory.create(:normal_person)      
    end
    context "and contribution does not belong to another contribution" do
      it "should return an error if it is not a top level contribution" do
        contribution = Contribution.create({:person=>@mock_person, :content => "Hello World"})
        contribution.errors.count.should_not == 0
      end
    end
    context "and contribution does not belong to another contribution" do
      it "should save successfully if it IS a top level contribution" do
        contribution = TopLevelContribution.create({:person=>@mock_person, :content => "Hello World"})
        contribution.errors.count.should == 0
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
        conversation = Factory.create(:conversation)
        contribution = TopLevelContribution.create({:conversation=>conversation, :person=>@mock_person, :content=>"Hello World"})
        conversation.contributions.count.should == 1
        conversation.contributions[0].should == contribution
      end
      it "should return a contribution with no errors" do
        conversation = Factory.create(:conversation)
        contribution = TopLevelContribution.create({:conversation=>conversation, :person=>@mock_person, :content=>"Hello World"})
        contribution.errors.count.should == 0
      end  
      it "should set the passed in user as the owner" do
        conversation = Factory.create(:conversation)
        contribution = Contribution.create({:conversation=>conversation, :person=>@mock_person, :content=>"Hello World"})
        contribution.person.should == @mock_person
      end    
    end
  end
end