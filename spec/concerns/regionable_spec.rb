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
      issue.region.should 
    end
  end
end

