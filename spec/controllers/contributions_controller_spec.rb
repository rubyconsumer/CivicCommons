require 'spec_helper'

describe ContributionsController do

  def mock_contribution(stubs={})
    @mock_contribution ||= mock_model(Contribution, stubs).as_null_object
  end

  describe "GET create_from_pa" do
    it "creates a new pa contribution for issue" do
      EmbeddedLinkValidator.stub!(:live_url?).and_return(true)
      EmbeddedLinkable.stub!(:get_link_information)

      person = Factory.create(:normal_person)
      issue = Factory.create(:issue)

      get :create_from_pa, {:person_id => person.id,
        :issue_id => issue.id,
        :link => "#{Civiccommons::PeopleAggregator.URL}/content/cid=42",
        :title => "Test Contribution Title"}

      response.should redirect_to(issue_url(issue))
    end

    it "creates a new pa contribution from issue" do
      EmbeddedLinkValidator.stub!(:live_url?).and_return(true)
      EmbeddedLinkable.stub!(:get_link_information)

      person = Factory.create(:normal_person)
      contribution = Factory.create(:top_level_contribution)
      contribution.save!
      conversation = contribution.conversation
      conversation.save!

      get :create_from_pa, {person_id: person.id,
                            parent_contribution_id: contribution.id,
                            conversation_id: conversation.id,
                            link: "#{Civiccommons::PeopleAggregator.URL}/content/cid=42",
                            title: "Test Contribution Title"}

      response.should redirect_to(conversation_url(conversation))
    end
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
