require 'spec_helper'


describe Region do

  it "joins county names into a country string" do
    county1 = County.new :name=>"fred", :state=>"PA"
    county2 = County.new :name=>"wilma", :state=>"PA"
    region = Region.new
    region.name = "jake"
    region.counties = [county1, county2]
    region.county_string = "fred\nwilma"
  end

  it "returns empty strings when there are no counties" do 
    region = Region.new
    region.county_string.should == ""
    region.state.should == ""
  end

  it "creates counties based upon the county string" do
    region = Region.new 
    region.state = "PA"
    region.county_string="Luzerne\nColumbia"
    region.counties.length.should == 2
    region.counties.first.state.should == "PA"
    region.counties.first.name.should == "Luzerne"
    region.counties.last.name.should == "Columbia"
  end


end
