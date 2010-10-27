require 'spec_helper'
require 'ostruct'

module PeopleAggregator::Connector
  extend ActiveSupport::Concern

  module ClassMethods
    def base_uri(uri)
    end
    def log_people_aggregator_response(r)
    end
  end
end

describe PeopleAggregator::Login do
  include PeopleAggregator


  before do
    response = OpenStruct.new(parsed_response: {"success" => true, "authToken" => "winston.tsang@test.com:1286416180:dd0667419e006d1c62fa617c0ea642ec93b4fcc1", "tokenLifetime" => 900}, code: 200)

    PeopleAggregator::Login.stub!(:post).and_return(response)
  end


  it "should log into People Aggregator" do
    p = PeopleAggregator::Login.login("winston.tsang@test.com", "some password hash")
    p.should_not be_nil
    p.authToken.should == "winston.tsang@test.com:1286416180:dd0667419e006d1c62fa617c0ea642ec93b4fcc1"
  end

end
