require 'spec_helper'

describe UserController do
  let(:user) do
    Factory.create(:normal_person)
  end

  def stub_person(stubs={})
    stub_model(Person, stubs)
  end

  context "GET 'show'" do
    it "retrieves users conversation, issues, and organization subscriptions" do
      Array.should_receive(:reverse).exactly(3).times
      Subscription.should_receive(:conversations).and_return(Array)
      Subscription.should_receive(:issues       ).and_return(Array)
      Subscription.should_receive(:organizations).and_return(Array)

      get :show, :id => user
    end

    it "retrieves most recent activity for the user" do
      Array.should_receive(:paginate).once
      array_of_activity = Array
      Activity.stub(:most_recent_activity_items_for_person).with(user).and_return(array_of_activity)

      get :show, :id => user
    end

    it "takes you to the community page if a user doesn't exist" do
      get :show, :id => 0

      response.should redirect_to(community_path)
    end
  end

  context "POST destroy_avatar" do

    def given_user_with_facebook_authenticated_and_without_avatar
      @person = stub_person(:facebook_authenticated? => true, :avatar => false, :facebook_profile_pic_url => 'graph.facebook.com/1234/picture')
    end

    def given_user_without_facebook_authenticated
      @person = stub_person(:facebook_authenticated? => false)
    end

    before(:each) do
      controller.stub(:verify_ownership?).and_return(true)
    end

    it "should return the avatar if have not been authenticated with Facebook " do
      given_user_without_facebook_authenticated
      Person.stub(:find).and_return(@person)
      @person.stub(:save).and_return(true)

      delete :destroy_avatar, :id => "1234", :format => :js
      response.should contain "{\"avatarUrl\":\"/images/avatar_70.gif\"}"
    end

    it "should return the Facebook url if account has already authenticated with Facebook" do
      given_user_with_facebook_authenticated_and_without_avatar
      Person.stub(:find).and_return(@person)
      @person.stub(:save).and_return(true)

      delete :destroy_avatar, :id => "1234", :format => :js
      response.should contain "{\"avatarUrl\":\"graph.facebook.com/1234/picture\"}"
    end

    it "should return 500 if unable to save" do
      @person = stub_person
      Person.stub(:find).and_return(@person)
      @person.stub(:save).and_return(false)

      delete :destroy_avatar, :id => '1234', :format => :js
      response.status.should == 500
    end
  end
end
