require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Authorization Threats", %q{
  As an attacker
  I want to circumvent authorization rules
  So I can access protected parts of the site
} do

  describe "when not logged in" do

    background do
      # Given an admin user exists
      # And I am not logged in
      @admin = Factory.create(:admin_person)      
      LoginPage.new(page).sign_out
    end

    scenario "illegally access a user profile page" do
      # When I visit a user's profile page
      # The I should not be on that user's profile page
      # And I should be redirected to the community page
      visit edit_user_path(@admin)
      current_path.should_not == edit_user_path(@admin)
      current_path.should == community_path
    end

    scenario "illegally access the admin pages" do
      # When I visit the admin page
      # Then I should not be on the admin page
      # And I should be redirected to the login page
      visit admin_root_path
      current_path.should_not == admin_root_path
      current_path.should == new_person_session_path
    end

  end

  describe "when logged in" do

    background do
      # Given an admin user exists
      # And an non-admin user exists
      # And I am logged in as the non-admin user
      @admin = Factory.create(:admin_person)      
      @user = Factory.create(:registered_user)      
      login_page = LoginPage.new(page)
      login_page.sign_in(@user)
    end

    scenario "illegally access a user profile page" do
      # When I visit a user's profile page
      # The I should not be on that user's profile page
      # And I should be redirected to the community page
      visit edit_user_path(@admin)
      current_path.should_not == edit_user_path(@admin)
      current_path.should == community_path
    end

    scenario "illegally access the admin pages" do
      # When I visit the admin page
      # Then I should not be on the admin page
      # And I should be redirected to home page
      visit admin_root_path
      current_path.should_not == admin_root_path
      current_path.should == root_path
    end

  end

end
