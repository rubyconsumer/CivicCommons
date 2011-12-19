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
    it "should has_many Authentications" do
      Organization.reflect_on_association(:authentications).macro == :has_many
    end
    it "should have organization details" do
      Organization.reflect_on_association(:organization_detail).macro == :has_one
    end
    it "should have many survey_responses" do
      Organization.reflect_on_association(:survey_responses).macro == :has_many
    end
  end
end
