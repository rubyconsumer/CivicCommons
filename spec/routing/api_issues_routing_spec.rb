require 'spec_helper'

describe Api::IssuesController do

  it "generates and recognizes #index" do
    { get: 'api/1/issues' }.should route_to(controller: 'api/issues', action: 'index', id: '1', format: :json)
  end

end
