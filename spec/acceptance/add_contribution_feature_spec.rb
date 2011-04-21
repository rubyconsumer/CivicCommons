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

end
