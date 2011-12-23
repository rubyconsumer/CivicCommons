require 'spec_helper'

describe Organization do
  subject { Factory.build(:organization) }

  it { should be_valid }
  it { subject.organization_detail.should_not be_blank }
  it { should have_attached_file :avatar }
  it { should validate_attachment_content_type(:avatar).allowing(["image/gif", "image/jpeg", "image/png", "image/bmp"])
    .rejecting(['text/plain']) }

  context "validation" do
    it "should validate on name" do
      org = Factory.build(:organization, :name=>'')
      org.valid?
      org.errors[:name].should == ["can't be blank"]
    end
    it "should not validate first_name and last_name" do
      org = Factory.build(:organization, :first_name=>'', :last_name => '')
      org.valid?
      org.errors[:first_name].should be_blank
      org.errors[:last_name].should be_blank
    end
  end
  context "Inheritance" do
    it "should be a subclass of Person" do
      Organization.superclass.should == Person
    end
  end
  
  context "Associations" do
    it "should have organization details" do
      Organization.reflect_on_association(:organization_detail).macro == :has_one
    end
    it "should have and belongs to many people" do
      Organization.reflect_on_association(:members).macro.should == :has_and_belongs_to_many
    end
    it "should be have uniqueness constraint on habtm members" do
      Organization.reflect_on_association(:members).options[:uniq].should be_true
    end
  end
  
  context "defaults" do
    it "should have allow_facebook_connect? to be false always" do
      Organization.new.allow_facebook_connect?.should be_false
    end
  end
  
  context "organization members" do
    before(:each) do
      @organization = Factory.create(:organization)
      @person = Factory.create(:person)
    end
    
    context "has_member?" do
      it "should have the proper member" do
        @organization.has_member?(@person).should_not be_true
        @organization.join_as_member(@person)
        
        @organization.reload
        @organization.has_member?(@person).should be_true
      end
    end
    context "join_as_members" do
      it "should add a person as a member" do
        @organization.join_as_member(@person)
        @organization.reload
        @organization.members.should == [@person]
      end
      it "should not allow to add the same person as a member" do
        @organization.join_as_member(@person)
        @organization.join_as_member(@person)
        @organization.members.should == [@person]
      end
    end
    context "remove_member" do
      it "should remove a person from membership of an arganization" do
        @organization.join_as_member(@person)
        @organization.reload
        @organization.members.should == [@person]
        @organization.remove_member(@person)
        @organization.members.should be_blank
      end
    end
  end
end
