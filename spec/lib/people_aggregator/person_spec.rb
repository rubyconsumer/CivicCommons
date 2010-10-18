require 'ostruct'

unless defined?(Rails)
  require 'active_support/concern'
  require 'active_support/hash_with_indifferent_access'
  require 'people_aggregator'

  require 'people_aggregator/api_object'
  require 'people_aggregator/person'
end

module PeopleAggregator::Connector
  extend ActiveSupport::Concern

  module ClassMethods
    def base_uri(uri)
    end
    def log_people_aggregator_response(r)
    end
    def log_people_aggregator_request(model, params)
    end
  end
end

describe PeopleAggregator::Person do
  include PeopleAggregator


  before do
    response = OpenStruct.new(parsed_response: {"success"=>true, "login"=>"joe@test.com", "id"=>14, "url"=>"#{Civiccommons::PeopleAggregator.URL}/user/14", "name"=>" ", "profile"=>{"basic"=>{"first_name"=>"Joe", "last_name"=>"Fiorini"}, "general"=>[], "personal"=>[], "professional"=>[]}}, code: 200)

    PeopleAggregator::Person.stub!(:post).and_return(response)
    PeopleAggregator::Person.stub!(:get).and_return(response)
  end


  it "finds a user based on email address" do
    p = PeopleAggregator::Person.find_by_email("joe@test.com")
    p.should_not be_nil
    p.login.should == "joe@test.com"
  end


  it "hydrates via hash" do
    Person.new(email: "joe@test.com").email.should == "joe@test.com"
  end


  specify "can save a person instance to People Aggregator" do
    person = PeopleAggregator::Person.new(firstName: "Joe",
                                          lastName: "Test",
                                          login: "joe@test.com")
    person.save
    person.id.should == 14
  end


end
