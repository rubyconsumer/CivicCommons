require 'spec_helper'

describe Api::ConversationsController do

  it "generates and recognizes #index" do
    { get: 'api/1/conversations' }.should route_to(controller: 'api/conversations', action: 'index', id: '1', format: :json)
  end

end
