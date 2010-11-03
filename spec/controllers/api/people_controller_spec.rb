require 'spec_helper'

describe Api::PeopleController do

  it "should return 200 on successful update" do
    person = Factory.create(:normal_person, :people_aggregator_id => 42)

    put :update, :people_aggregator_id => 42
    response.should be_success
  end

  it "should return 404 when not found" do
    person = Factory.create(:normal_person, :people_aggregator_id => 42)

    put :update, :people_aggregator_id => 43
    response.status.should == 404
  end

    it "should return unprocessable entity on bad update" do
    person = Factory.create(:normal_person, :people_aggregator_id => 42)

    # try changing the email address to something invalid
    put(:update, :people_aggregator_id => 42, :person => {:email => "foo"})
    response.status.should == 422
  end
end
