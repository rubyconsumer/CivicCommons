require 'spec_helper'


describe model_type.to_s, "#load_region" do
  let (:issue) { Factory.create(:issue) }

  before(:each) do 
    issue.zip_code = "11111"
  end

  context "a region exists for its zipcode" do

    before(:each) do
      Region.expects(:find_by_zip_code).and_returns(:region)   
    end

    it "finds the correct region from its zipcode" do
      issue.region.should == :region
    end

  end

end

