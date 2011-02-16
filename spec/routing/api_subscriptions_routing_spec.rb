require 'spec_helper'

describe Api::SubscriptionsController do

  it "generates and recognizes #index" do
    { get: '/api/people-aggregator/person/1/subscriptions' }.should route_to(controller: 'api/subscriptions', action: 'index', id: '1', format: :json)
  end

end
