require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Regional Filter", %q{
  As a visitor or user,
  I should be able to filter contents based on regions
  So that I can get relevant content to my location
} do

  def stub_metro_region_search
    #stub the search MetroRegion.search on the search controller
    metro_regions = MetroRegion.all
    MetroRegion.should_receive(:search).and_return(metro_regions)
    metro_regions.stub!(:results).and_return(metro_regions)
  end

  def given_site_contents
    @metro_region1 = FactoryGirl.create(:metro_region, :metrocode => 510,  :display_name => 'Region 1')
    @metro_region2 = FactoryGirl.create(:metro_region, :metrocode => 511,  :display_name => 'Region 2')
    @metro_region3 = FactoryGirl.create(:metro_region, :metrocode => 512,  :display_name => 'Region 3')
    @metro_region4 = FactoryGirl.create(:metro_region, :metrocode => 513,  :display_name => 'Region 4')
    @metro_region5 = FactoryGirl.create(:metro_region, :metrocode => 514,  :display_name => 'Region 5')
    @metro_region6 = FactoryGirl.create(:metro_region, :metrocode => 515,  :display_name => 'Region 6')

    @conversation1 = FactoryGirl.create(:conversation, :title => 'Conversation 1', :metro_region => @metro_region1)
    @conversation2 = FactoryGirl.create(:conversation, :title => 'Conversation 2', :metro_region => @metro_region2)
    @conversation3 = FactoryGirl.create(:conversation, :title => 'Conversation 3', :metro_region => @metro_region3)
    @conversation4 = FactoryGirl.create(:conversation, :title => 'Conversation 4', :metro_region => @metro_region4)
    @conversation5 = FactoryGirl.create(:conversation, :title => 'Conversation 5', :metro_region => @metro_region5)
    @conversation6 = FactoryGirl.create(:conversation, :title => 'Conversation 6', :metro_region => @metro_region6)
  end


  scenario "filter slide out", :js => true do
    #setups
    given_site_contents
    stub_metro_region_search

    # visit conversation page
    visit conversations_path
    set_current_page_to :conversations

    # I should not have any regional filter when I first visit the site
    current_page.should have_content 'Region 1'
    current_page.should have_content 'Region 2'
    current_page.should have_content 'Region 3'
    current_page.should have_content 'Region 4'
    current_page.should have_content 'Region 5'
    current_page.should_not have_content 'Region 6'
    current_page.should_not have_css(".region-slideout")

    # click one of the top metro region filter
    current_page.click_link_or_button('Region 1')

    # regional filter tab bar should be displayed
    current_page.should have_css(".region-slideout")
    current_page.should have_content 'Conversation 1'
    current_page.should_not have_content 'Conversation 6'

    # click on the filter tab
    current_page.find(:css,'.expand-region-tab').click

    # and it should expand the filter tab
    within(:css, '.region-slideout') do
      current_page.should have_content 'Region 1'
      current_page.should have_content 'Recent'
    end

    within(:css, '.region-slideout') do
      # change the filter
      current_page.click_link_or_button 'Change Location'

      # it should show change filter title
      current_page.should have_content 'Change Location'

      # entering search, new york, new york
      fill_in('region-filter-input',:with=>'city')
    end

    sleep 2
    find('.ui-menu-item:last a:first').click

    # press submit button
    current_page.click_link_or_button 'Filter'

    # it should only show conversation 6
    current_page.should_not have_content 'Conversation 1'
    current_page.should have_content 'Conversation 6'

    # click to expand the current filter
    current_page.find(:css,'.expand-region-tab').click

    # click remove the filter
    current_page.click_link 'remove filter'

    # tab bar should not be shown
    current_page.should_not have_css(".region-slideout")
  end


end
