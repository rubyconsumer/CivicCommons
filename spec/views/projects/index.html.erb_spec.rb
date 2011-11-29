require 'spec_helper'
describe '/projects/index.html.erb' do

  before(:each) do
    Factory.create(:managed_issue,
      index_summary: 'custom index summary',
      summary: 'original summary'
    )
  end

  it "should show the ManagedIssues's index summaries" do
    @recent_items = []
    @projects = Issue.where(:type => 'ManagedIssue').where(:exclude_from_result => false).paginate(:page => params[:page], :per_page => 20)
    render
    rendered.should contain 'custom index summary'
  end

end