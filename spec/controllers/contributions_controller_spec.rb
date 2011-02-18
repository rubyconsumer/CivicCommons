require 'spec_helper'

describe ContributionsController do

  def mock_contribution(stubs={})
    @mock_contribution ||= mock_model(Contribution, stubs).as_null_object
  end


 # describe "DELETE" do
 #   it "destroys the requested contribution" do
 #     Contribution.should_receive(:find).with("37").and_return(mock_contribution)
 #     mock_contribution.owner = current_person
 #     mock_contribution.should_receive(:destroy)
 #     delete :destroy, :id => "37"
 #   end
 # end

end
