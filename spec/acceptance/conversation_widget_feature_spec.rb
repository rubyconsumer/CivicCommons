require 'acceptance/acceptance_helper'

feature "Conversation Widget Feature", %q{
  As a visitor to a CC Partner Site
  I want to see contents from CC that's related to the site
  So that I can become engaged and interested in joining CC
} do
  
  before(:all) do
    ActiveRecord::Observer.enable_observers
  end

  after(:all) do
    ActiveRecord::Observer.disable_observers
  end
  
  background do
    @conversation = FactoryGirl.create(:conversation, :title => 'Akron Beacon Journal Seeks Citizen Views', :summary => 'Conversation Summary Here')
    @person = FactoryGirl.create(:normal_person)
    @contribution1 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 1'})
    @contribution2 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 2'})
    @contribution3 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 3'})
    @contribution4 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 4'})
    @contribution5 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 5'})
    @contribution6 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 6'})
    @contribution7 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 7'})
  end
  scenario "Widget", :js => true do
    visit '/example_cc_widget_for_rspec'
    sleep 2
    page.should have_content 'Akron Beacon Journal Seeks Citizen Views'
    page.should have_content 'Conversation Summary Here'
    page.should have_content('Contribution Title here')
    page.click_link('See More Activity')
    sleep 2
    page.should_not have_content('See More Activity')
  end

end
