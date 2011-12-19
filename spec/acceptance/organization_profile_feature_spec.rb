require_relative 'acceptance_helper'

feature "Organization Profiles", %q{
  In order to publicize my organization
  As an organization
  I would like a profile for it on the Civic Commons
} do

  background do
    @organization = database.has_an_organization
  end
  scenario "Joining an Organization", :pending=>true do

  end
  scenario "Following an organization", :pending=>true do

  end

  scenario "Viewing an Organization Profile", :pending=>true do
    goto :organization_profile, for: organization
    current_page.should have_pluralized_itself
    current_page.should have_contact_info_for organization
  end

  def organization
    @organization
  end

    #current_page.should have_content "Conversations we are following"
    #current_page.should have_content "Issues we are following"
    #current_page.should have_content "Our recent activity"
end
