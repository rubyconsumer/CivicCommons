require 'active_support/concern'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/array/conversions'
require 'people_aggregator/api_object'


include PeopleAggregator

class ApiObjectDummy
  include ApiObject


end

describe ApiObject do


  it "enables defining allowed attributes" do
    ApiObjectDummy.attr_allowable :foo
    ApiObjectDummy.new(foo: 'bar').foo.should == 'bar'
  end


  it "does not allow initializing with undefined methods" do
    lambda { ApiObjectDummy.new(baz: 'qux') }.should raise_error(ArgumentError)
  end


  it "allows calling attr_allowable more than once" do
    lambda {
      ApiObjectDummy.attr_allowable :quux
      ApiObjectDummy.attr_allowable :corge

      ApiObjectDummy.new(quux: 'grault', corge: 'garply')
    }.should_not raise_error
  end


  it "allows setting multiple allowed attributes at once" do
    ApiObjectDummy.attr_allowable :waldo, :fred

    lambda { ApiObjectDummy.new(waldo: 'plugh', fred: 'xyzzy') }.
      should_not raise_error
  end


  it "is agnostic to whether a key is a string or symbol" do
    ApiObjectDummy.attr_allowable :thud

    lambda { ApiObjectDummy.new("thud" => "wibble") }.should_not raise_error
  end


  it "allows setting attributes defined as allowable after initialization" do
    ApiObjectDummy.attr_allowable :wobble
    lambda { ApiObjectDummy.new.wobble = "wubble" }.should_not raise_error
  end
end
