require 'spec_helper'


describe Regionable, "#load_region" do
  let (:issue) { Factory.create(:issue) }

  before(:each) do 
    issue.zip_code = "11111"
  end

  context "when a region exists for its zipcode" do
    before(:each) do
      Region.should_receive(:find_by_zip_code).with("11111").and_return(:region)   
    end

    it "finds the correct region from its zipcode" do
      issue.region.should == :region
    end
  end

  context "when no region exists for its zipcode" do

    before(:each) do
      Region.should_receive(:find_by_zip_code).with("11111").and_return(nil)   
    end

    it "returns a default region" do
      issue.region.name.should == Region.default.name
    end

  end

  describe "class methods" do

    before(:each) do
      @region = Region.new(:name => "blah")
      @region.zip_code_string = "12345\n33333"
      @region.save
      issue.zip_code = "12345"
      issue.save
    end

    it "adds a class method to region that finds all of its type" do 
      @region.zip_codes.length.should == 2
      @region.issues.first.id.should == issue.id
    end

  end
end

