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
    fill_in 'contribution_content', :with => "the cat in the hat"
    #And I click the preview button
    click_button('Preview')
    #Then I should see a preview modal with the content “the cat in the hat”
    find(".content p").text.should == "the cat in the hat"
    #And I should I should see a submit button
    find('#contribution_submit').should_not be_nil
    #And I should I should see a cancel link
    find('a.cancel').should_not be_nil
  end

end
