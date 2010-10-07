require 'spec_helper'

describe Admin::RegionsController do 

  before(:each) do
    @controller.stub(:verify_admin).and_return(true)
  end

  describe "GET index" do 
    it "should show all regions" do 
      Region.stub(:all).and_return(:regions)
      get :index
      assigns(:regions).should == :regions
    end
  end

  describe "GET edit" do
  
    before(:each) do
      county1 = County.new :name=>"fred", :state=>"PA"
      county2 = County.new :name=>"wilma", :state=>"PA"
      @region = Region.new
      @region.name = "jake"
      @region.counties = [county1, county2]
      Region.stub(:find).with(1).and_return(@region)
      get :edit, :id=>1
    end

    it "should assign to region" do
      assigns(:region).should == @region
    end

  end

  describe "GET new" do
    it "should assign to region" do
      Region.stub(:new).and_return(:region)
      get :new
      assigns(:region).should == :region
    end
  end

  describe "POST create" do
    context "with valid params" do 
      it "should create counties based on the params" do
        post :create, :region => {:name=>"john", :state=>"pa", :county_string=>"a\nb"}
        assigns(:region).counties.length.should == 2
        assigns(:region).counties.first.state.should == "pa"
      end
    end
  end
  
end
