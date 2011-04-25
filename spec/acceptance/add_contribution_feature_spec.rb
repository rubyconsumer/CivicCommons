require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!

feature "Add contribution", %q{
  As a Civic Commons registered user
  I want to add a contribution
  So that I can interact with the Civic Commons community
} do

  before :each do
    logged_in_user
    @contribution = Factory.create(:comment, :override_confirmed => true)
    @conversation = @contribution.conversation
  end

  scenario "Modal pops up when user responds to a conversation", :js => true do
    #Given I am on a conversation permalink page
    visit conversation_path(@conversation)
    #When I click on the contribute to conversation button
    click_link('Post to this Conversation')
    #Then I should see a contribution modal overlay appear
    find('#cboxContent').should_not be_nil
    #And I should see links to comment
    find_link('Comment').should_not be_nil
    #And I should see links to suggest action
    find_link('Suggest Action').should_not be_nil
    #And I should see links to question
    find_link('Question').should_not be_nil
    #And I should see links to attach
    find_link('Attach').should_not be_nil
    #And I should see links to link 
    find_link('Link').should_not be_nil
    #And I should see links to video
    find_link('Video').should_not be_nil
    #And I should see comments selected
    find('.tab-active').text.should == 'Comment'
  end

  scenario "Modal pops up when responding to contribution", :js => true do
    #Given that I am on a conversation permalink page
    visit conversation_path(@conversation)
    #And I am on a conversation node
    visit "#{conversation_path(@conversation)}#node-#{@contribution.id}"
    #When I click on the respond to contribution link
    click_link("Respond to #{Person.find(@contribution.owner).first_name}")
    #Then I should see the contribution modal overlay appear
    find('#cboxContent').should_not be_nil
  end

  scenario "Previewing a comment", :js => true do
    #Given that I am at the contribution modal
    visit conversation_path(@conversation)
    click_link('Post to this Conversation')
    #When I fill in the comments text box with “the cat in the hat”
    page.has_css?('textarea#contribution_content', visible: true)
    fill_in 'contribution_content', :with => "the cat in the hat"
    #And I click the preview button
    click_button('Preview')
    #Then I should see a preview modal with the content “the cat in the hat”
    find("#cboxLoadedContent div.comment div.content p").should_not be_nil
    page.should have_content "the cat in the hat"
    #And I should I should see a submit button
    page.has_css?('#contribution_submit').should be_true
    #And I should I should see a cancel link
    page.has_css?('a.cancel').should be_true
  end

  scenario "Posting a comment", :js => true do
    #Given I have previewed a comment for a contribution
    preview_comment(@conversation, "the cat in the hat")
    #When I submit I should be back on the conversation page 
    find('#contribution_submit', visible: true).click
    #Then I should be directed back to the contribution
    visit "#{conversation_path(@conversation)}#node-#{@conversation.contributions.last.id}"
    #And this contribution should be on the conversation page
    page.has_content?('the cat in the hat').should be_true
  end

end
