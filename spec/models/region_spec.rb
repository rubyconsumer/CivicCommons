require 'spec_helper'


describe Region do
  
  describe "default" do 
    it "has a name of national" do 
      Region.default.name.should == "National"
    end
  end

  it "joins zip_codes into a zip_code string" do
    zip_code = ZipCode.new :zip_code=>"11111"
    zip_code2 = ZipCode.new :zip_code=>"12345"
    region = Region.new
    region.name = "jake"
    region.zip_codes = [zip_code, zip_code2]
    region.zip_code_string = "11111\n12345"
  end

  it "returns empty strings when there are no zip_codes" do 
    region = Region.new
    region.zip_code_string.should == ""
  end

  it "creates zip_codes based upon the zip_code string" do
    region = Region.new 
    region.zip_code_string="12345\n11111"
    region.zip_codes.length.should == 2
    region.zip_codes.first.zip_code.should == "12345"
    region.zip_codes.last.zip_code.should == "11111"
  end


end
