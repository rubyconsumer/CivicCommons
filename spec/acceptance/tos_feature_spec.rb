require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Report Terms of Service Violation", %q{
  As a registered user,
  I want to report content that violates the Terms of Service
  So that action can be taken by site management
} do


  scenario "Display the Report Abuse text" do
    given_i_am_on_a_conversation_page_with_a_contribution
    then_the_page_has_a_report_abuse_link
  end

  def then_the_page_has_a_report_abuse_link
    page.should have_link("Alert us.")
  end
  def given_i_am_on_a_conversation_page_with_a_contribution
    contribution = Factory :contribution
    conversation_page = ConversationsPage.new(page)
    conversation_page.visit_conversations(contribution.conversation)
  end
end
