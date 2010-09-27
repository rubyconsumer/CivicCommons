require 'ostruct'

unless defined?(Rails)
  require 'active_support/concern'
  require 'people_aggregator'

  module PeopleAggregator::Connector
    extend ActiveSupport::Concern

    module ClassMethods
      def base_uri(uri)
      end
      def log_people_aggregator_response(r)
      end
    end
  end

  require 'people_aggregator/person'
end

describe PeopleAggregator::Person do
  include PeopleAggregator


  before do
    response = OpenStruct.new(parsed_response: {"success"=>true, "login"=>"joe@test.com", "id"=>"user:14", "url"=>"http://civiccommons.digitalcitymechanics.com/user/14", "name"=>" ", "profile"=>{"basic"=>{"first_name"=>"Joe", "last_name"=>"Fiorini"}, "general"=>[], "personal"=>[], "professional"=>[]}}, code: 100)
    Person.stub!(:post).and_return(response)
    Person.stub!(:get).and_return(response)
  end


  it "finds a user based on email address" do
    p = Person.find_by_email("joe@test.com")
    p.should_not be_nil
    p.login.should == "joe@test.com"
  end


  it "hydrates via hash" do
    Person.new(email: "joe@test.com").email.should == "joe@test.com"
  end


  specify "can save a person instance to People Aggregator" do
    Person.should_receive(:post).with(anything,
                                      body: {
                                      firstName: "Joe",
                                      lastName: "Test",
                                      adminPassword: "admin",
                                      login: "joe@test.com"})
    Person.new(firstName: "Joe", lastName: "Test", login: "joe@test.com").
      save
  end


end
