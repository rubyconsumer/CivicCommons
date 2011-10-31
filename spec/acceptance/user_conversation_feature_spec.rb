require 'acceptance/acceptance_helper'

feature "User Creates a User-Conversation", %q{
  As a normal user,
  I want to start a converastion and invite others to join
} do
  background do
    database.create_issue name: "They are important"
  end


  scenario "starting a conversation", :js => true do
    login_as :person
    follow_start_conversation_link
    agree_to_responsibilities
    fill_in_conversation

    submit

    the_current_page.should be_the_invite_a_friend_page_for_the conversation
    conversation.should exist_in_the_database
  end
  

  scenario "inviting a friend when starting a conversation", :js => true do
    login_as :person
    follow_start_conversation_link

    agree_to_responsibilities
    fill_in_conversation
    submit
    invite_a_friend
    friend.should have_been_sent_an_invitation_to_join conversation
  end


  def invite_a_friend
    @friend = Friend.new('email@address.com')
  end

  def friend
    @friend
  end
  class Friend
    def has_been_sent_an_invitation_to_join?(conversation)

    end
  end


end

