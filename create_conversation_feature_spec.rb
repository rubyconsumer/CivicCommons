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
    submit_conversation
    conversation.should exist_in_the_database
    the_current_page.should be_the_invite_a_friend_page_for_the conversation
  end
  

  scenario "inviting a friend when starting a conversation", :js => true do
    login_as :person
    follow_start_conversation_link

    agree_to_responsibilities
    submit_conversation
    invite friend
    friend.should have_been_sent_an_invitation_to_join conversation
  end
  def friend
    Friend.new('bla@goolge.com') 
  end
    class Friend
      attr_accessor :email
      def initialize(email)
        self.email = email
      end
      def has_been_sent_an_invitation_to_join?(conversation)
        mailing = ActionMailer::Base.deliveries.last
        expected_subject = "wants to invite you to a conversation"

        mailing.to.include? email and mailing.subject.include? expected_subject and mailing.body.include? "#{conversation.title}"
      end
    end
end
