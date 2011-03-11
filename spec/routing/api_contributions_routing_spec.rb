require 'spec_helper'

describe Api::ContributionsController do

  it "generates and responds to #index" do
    { get: '/api/1/contributions/' }.should route_to(controller: 'api/contributions', action: 'index', id: '1', format: :json)
  end

end
