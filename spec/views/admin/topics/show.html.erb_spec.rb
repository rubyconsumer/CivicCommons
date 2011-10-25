require 'spec_helper'

describe "admin/topics/show.html.erb" do
  before(:each) do
    @topic = assign(:topic, stub_model(Topic,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
