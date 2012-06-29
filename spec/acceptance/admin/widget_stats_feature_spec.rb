require 'acceptance/acceptance_helper'

feature " Widget Stats", %q{
  As an admin user
  When I want to see widget stats
  I should be able to view it on admin interface
} do
  include Admin::WidgetStatsHelper
  def value_for_week(week_of=0)
    @week_ranges ||= weeks_ago_date_range_select
    week = @week_ranges.select{|r| r[1] == week_of}
    week[0][0] if week
  end
  def given_some_widget_logs
    @widget_log1 = FactoryGirl.create(:widget_log, url: '/url/here', remote_url: 'http://remote.url/here')
    @widget_log2 = FactoryGirl.create(:widget_log, url: '/url/here', remote_url: 'http://remote.url/here')
    @widget_log3 = FactoryGirl.create(:widget_log, url: '/url/here', remote_url: 'http://remote.url2/here')
  end
  scenario "Viewing the stat", :js => true do
    given_some_widget_logs
    login_as :admin_person
    visit admin_widget_stats_path
    # Index page
    set_current_page_to :admin_widget_stats
    page.should have_content 'Your Commons Stats'
    page.should have_content @widget_log1.url
    fill_in_week_of_with value_for_week(3)
    page.should_not have_content @widget_log1.url
    fill_in_week_of_with value_for_week(0)
    page.should have_content @widget_log1.url
    
    follow_expand_link
    # Show page
    page.should have_content 'Showing Your Commons Stat for:'
    page.should have_content @widget_log1.remote_url
    page.should have_content @widget_log3.remote_url
    
    fill_in_week_of_with value_for_week(3)
    page.should_not have_content @widget_log1.remote_url
    page.should_not have_content @widget_log3.remote_url
    
    
  end
  
end