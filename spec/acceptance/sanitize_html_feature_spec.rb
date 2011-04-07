require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Sanitize HTML from user generated content", %q{
  In order to protect the Civic Commons website from attacks
  As a developer
  I want to remove potentially malicious HTML tags
} do
  
  context "Contributions" do
    
    background do
      @conversation = Factory.create(:conversation)
    end
    
    scenario "Remove script tags" do
      @contribution = Factory.create(:contribution, content: "<script>alert('testing');</script>This should alarm you", conversation: @conversation)
      
      visit conversation_path(@conversation)
      puts page.body
      contributed_content = find_by_id("show-contribution-#{@contribution.id}")
      contributed_content.should have_content('This should alarm you')
    end
    
  end
  
end