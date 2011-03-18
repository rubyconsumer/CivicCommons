require 'spec_helper'

describe UnsubscribeDigestController do

  describe 'GET: confirm' do

    it "assigns the person to @person" do
      person = mock_model(Person)
      Person.should_receive(:find).with('27').and_return(person)
      get :unsubscribe_me, id: '27'
      assigns(:person).should == person
    end

  end

  describe "PUT: #remove_from_digest" do

    it "updates daily_digest attribute to false" do
      person = mock_model(Person)
      Person.should_receive(:find).with('27').and_return(person)
      person.should_receive(:update_attributes).with(daily_digest: false).and_return(true)

      put :remove_from_digest, id: '27'
    end

    it "redirects back to the home page" do
      person = mock_model(Person)
      Person.should_receive(:find).with('27').and_return(person)
      person.should_receive(:update_attributes).with(daily_digest: false).and_return(true)

      put :remove_from_digest, id: '27'
      response.should redirect_to(root_path)
    end

  end

end
