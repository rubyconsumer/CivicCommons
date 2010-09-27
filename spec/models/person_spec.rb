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
  
  describe "when displaying a name" do
    it "should properly capitalize a persons name" do
      person = Factory.create(:normal_person)
      person.first_name = "ektor"
      person.last_name = "van capsula"
      person.name.should == "Ektor Van Capsula"
    end
    
    it "should display names without leading spaces when the first name is missing" do
      person = Factory.create(:normal_person)
      person.first_name = ""
      person.last_name = "van capsula"
      person.name.should == "Van Capsula"
    end
    
    it "should display names without trailing spaces when the last name is missing" do
      person = Factory.create(:normal_person)
      person.first_name = "ektor"
      person.last_name = ""
      person.name.should == "Ektor"
    end
  end
end
