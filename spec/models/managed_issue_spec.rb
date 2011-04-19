require 'spec_helper'

describe ManagedIssue do

  context "validations" do

    let(:attributes) {
      Factory.attributes_for(:managed_issue)
    }

    it "should validate a valid object" do
      ManagedIssue.new(attributes).should be_valid
    end

    it "should require a name" do
      attributes.delete(:name)
      ManagedIssue.new(attributes).should_not be_valid
    end

    it "should require the name to be unique" do
      mi = Factory.create(:managed_issue)
      attributes[:name] = mi.name
      attributes[:url_title] = mi.url_title + '_uniqueness'
      ManagedIssue.new(attributes).should_not be_valid
    end

    it "should allow a null index_page" do
      attributes.delete(:index_page)
      ManagedIssue.new(attributes).should be_valid
    end

  end

end
