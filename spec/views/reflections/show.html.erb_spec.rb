require 'spec_helper'
include ControllerMacros

describe "reflections/show.html.erb" do
  before(:each) do
    @reflection = Factory.create(:reflection)
  end

  it "renders attributes in <p>", :pending => true do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end

  it "renders the moderation tools for reflection if logged in as an admin" do
    login_admin
    assign(:conversation, @reflection.conversation)
    assign(:reflection, @reflection)
    render
    rendered.should match(/<div class=\"main-content\">\s*<p class=\"fl-right alert alert-admin\">\s*<strong>Moderate:<\/strong>/)
  end

  it "does not render the moderation tools for reflection if not logged in as an admin" do
    login_user
    assign(:conversation, @reflection.conversation)
    assign(:reflection, @reflection)
    render
    rendered.should_not match(/<div class=\"main-content\">\s*<p class=\"fl-right alert alert-admin\">\s*<strong>Moderate:<\/strong>/)
  end

  it "does not render the moderation tools for reflection if not logged in" do
    assign(:conversation, @reflection.conversation)
    assign(:reflection, @reflection)
    render
    rendered.should_not match(/<div class=\"main-content\">\s*<p class=\"fl-right alert alert-admin\">\s*<strong>Moderate:<\/strong>/)
  end
end
