require 'spec_helper'

# A mock for the Search service.
# WebMock requires us to know which URLs are called from within the gem.
# Is it better to mock the API interface or mock the API internals?
# This approach mocks the API.
class MockSearch
  def initialize(json)
    @json = json
  end

  def objectify(opts = {})
    return Array[self]
  end

  def marshal_dump
    SearchService.parse_raw(@json)
  end
end

describe SearchService do

  context "Initialization" do

    before(:each) do
      @mock_search = mock('search')
      @search = SearchService.new(@mock_search)
    end

    it "should pass all options through to Search" do
      params = Hash.new
      params[:q] = "Town"

      @mock_search.should_receive(:search).with([Conversation]).and_return(@mock_search)
      @mock_search.should_receive(:each_hit_with_result).and_return([])
      @search.fetch_results(params[:q], Conversation).should == []
    end

    it "should return an empty set of results" do
      @mock_search.should_receive(:search).and_return(@mock_search)
      @mock_search.should_receive(:each_hit_with_result).and_return([])
      @search.fetch_results().should == []
    end
  end
end
