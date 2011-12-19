require 'spec_helper'

describe Organization do
  subject { Factory.build(:organization) }

  it { should be_valid }
  it { should have_attached_file :avatar }
  it { should validate_attachment_content_type(:avatar).allowing(["image/gif", "image/jpeg", "image/png", "image/bmp"])
    .rejecting(['text/plain']) }

  context "Inheritance" do
    it "should be a subclass of Person" do
      Organization.superclass.should == Person
    end
  end
  context "Associations" do
    it "should has_many Authentications" do
      Organization.reflect_on_association(:authentications).macro == :has_many
    end
    it "should have many survey_responses" do
      Organization.reflect_on_association(:survey_responses).macro == :has_many
    end
  end
end
