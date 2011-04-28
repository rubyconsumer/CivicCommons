require 'spec_helper'

describe ManagedIssuePage do
  
  before(:all) do
    @author = Factory.build(:admin_person)
    @issue = Factory.build(:managed_issue)
  end

  before(:each) do
    @attr = Factory.attributes_for(:managed_issue_page)
    @attr[:issue] = @issue
    @attr[:author] = @author
  end

  context "validations" do

    it "creates a valid object" do
      ManagedIssuePage.new(@attr).should be_valid
    end

    it "validates the presence of name" do
      @attr.delete(:name)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

    it "validates the presence of template" do
      @attr.delete(:template)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

    it "validates the presence of issue" do
      @attr.delete(:issue)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

    it "validates that the issue is a managed issue" do
      @attr[:issue] = Factory.build(:issue)
      lambda { ManagedIssuePage.new(@attr) }.should raise_error
    end

    it "validates the presence of author" do
      @attr.delete(:author)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

    it "validates the uniqueness of the name" do
      ManagedIssuePage.new(@attr).save
      @attr[:template] = 'new stuff'
      @attr[:cached_slug] = 'new_stuff'
      @attr[:author] = Factory.build(:admin_person, :id => @author.id+1)
      ManagedIssuePage.new(@attr).should_not be_valid
    end

  end

end
