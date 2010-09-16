require 'spec_helper'

describe Person do
  describe "when setting the name" do
    it "should split the entry into first name and last name" do
      person = Factory.create(:normal_person)
      person.name = "John Doe"
      person.first_name.should == "John"
      person.last_name.should == "Doe"
    end
  end
  context "as participants of an issue" do
    def given_an_issue_with_conversations_and_participants
      @issue = Factory.create(:issue, )
      @person1 = Factory.create(:normal_person)
      @person2 = Factory.create(:normal_person)
      @person3 = Factory.create(:normal_person)
      @conversation1 = Factory.create(:conversation,:guides => [@person1,@person2],:issues => [@issue])
      @conversation2 = Factory.create(:conversation,:guides => [@person1],:issues => [@issue])
    end
    it "should return the correct participants" do
      given_an_issue_with_conversations_and_participants
      Person.participants_of_issue(@issue).should == [@person1,@person2]
    end
    it "should return the correct number of participants" do
      given_an_issue_with_conversations_and_participants
      Person.participants_of_issue(@issue).count('DISTINCT(people.id)').should == 2
    end
  end
end