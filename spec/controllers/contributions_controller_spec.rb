require 'spec_helper'

describe ContributionsController do

  context "DELETE: Contribution" do

    it "assigns @contribution" do
      contribution = mock_model(Contribution)
      Contribution.should_receive(:find).and_return(contribution)
      contribution.stub(:destroy_by_user)

      delete :destroy, id: 1
      assigns(:contribution).should == contribution
    end

    it "removes the contribution if the user is an admin or the original contributor" do
      contribution = mock_model(Contribution)
      Contribution.stub(:find).and_return(contribution)
      contribution.should_receive(:destroy_by_user)

      delete :destroy, id: 1
    end

    it "returns status ok on success" do
      contribution = mock_model(Contribution)
      Contribution.stub(:find).and_return(contribution)
      contribution.stub(:destroy_by_user) { contribution }

      delete :destroy, id: 1, format: :js
      response.status.should == 200
    end

    it "returns error messages on failure" do
      contribution = mock_model(Contribution)
      Contribution.stub(:find).and_return(contribution)
      contribution.stub(:destroy_by_user) { false }

      delete :destroy, id: 1, format: :js
      response.body.should == "{}"
    end

    it "returns error messages on failure" do
      contribution = mock_model(Contribution)
      Contribution.stub(:find).and_return(contribution)
      contribution.stub(:destroy_by_user) { false }

      delete :destroy, id: 1, format: :js
      response.status.should == 422
    end

  end

end
