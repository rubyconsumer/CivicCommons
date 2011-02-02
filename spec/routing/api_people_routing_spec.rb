require 'spec_helper'

describe Api::PeopleController do

  it "generates and recognizes #update" do
    { put: 'api/people-aggregator/person/1' }.should route_to(controller: 'api/people', action: 'update', people_aggregator_id: '1', format: :json)
  end

end
