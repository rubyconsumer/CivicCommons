require 'spec_helper'

describe CommunityController do
  def mock_person
    mock_model(Person).as_null_object 
  end
  describe "index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
    it "should order the people" do
      controller.should_receive(:ordered_people)
      get :index
    end
    it "should get all region" do
      Region.should_receive(:all)
      get :index
    end
    describe "ordered_people" do
      context "with newest-member" do
        it "should sort by the most recent newest members who have confirmed" do 
          Person.should_receive(:find_confirmed_order_by_recency).and_return(mock_person)
          get :index, :order => 'newest-member'
          response.should be_success
        end
        it "should set the subtitle to 'Newest Members'" do
          get :index, :order => 'newest-member'
          assigns(:subtitle).should == 'Newest Members'
        end
      end
      context "with alphabetical" do
        it "should sort by alphabet of last name" do
          Person.should_receive(:find_confirmed_order_by_last_name).and_return(mock_person)
          get :index, :order => 'alphabetical'
          response.should be_success
        end
        it "should set the subtitle to 'Alphabetical'" do
          get :index, :order => 'alphabetical'
          assigns(:subtitle).should == 'Alphabetical'
        end
      end
      context "with most active" do
        it "should sort by the most active users" do
          Person.should_receive(:find_confirmed_order_by_most_active).and_return(mock_person)
          get :index, :order => 'active-member'
          response.should be_success
        end
        it "should set the subtitle to 'Most Active'" do
          get :index, :order => 'active-member'
          assigns(:subtitle).should == 'Most Active'
        end
      end
      context "default" do
        it "should sort by the most active members" do 
          Person.should_receive(:find_confirmed_order_by_most_active).and_return(mock_person)
          get :index
          response.should be_success
        end
        it "should set the subtitle to 'Most Active'" do
          get :index
          assigns(:subtitle).should == 'Most Active'
        end
      end
    end
  end
end
