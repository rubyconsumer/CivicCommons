require 'acceptance/acceptance_helper'

feature "User Creates a User-Conversation", %q{
  As a normal user,
  I want to start a converastion and invite others to join
} do

  scenario "starting a conversation" do
    login
    start_conversation
    agree_to_responsibilities
    fill_in_the_conversation
    submit

    the_page_im_on.should be_the_invite_a_friend_page_for_the conversation 
    conversation.should exist_in_the_database
  end
  

  scenario "inviting a friend when starting a conversation" do
    login
    start_conversation
    agree_to_responsibilities
    fill_in_the_conversation
    submit
    invite_a_friend
    friend.should have_been_sent_an_invitation_to_join conversation
  end

  def start_conversation
    click_link "Start a Conversation"
  end

  def agree_to_responsibilities
    click_link "I agree, continue"

  end

  def fill_in_the_conversation
    fill_in_title_with "Frank"
    fill_in_summary_with "stufffff!"
    fill_in_content_with "COOL! THIS IS AWESOME"
  end

  def submit
    click_button "Start My Conversation"
    
  end

  def invite_a_friend
    @friend = Friend.new('email@address.com')
  end

  def conversation
    @conversation = Conversation.find_by_title("Frank")
    p @conversation
    @conversation
  end

  def friend
    @friend
  end
  class Friend
    def has_been_sent_an_invitation_to_join?(conversation)

    end
  end

  def self.add_input_field(field, options)
    define_method "fill_in_#{field}_with" do | value |
      fill_in options[:find_with], :with=> value
    end
  end

  add_input_field(:title, :find_with => "Title")
  add_input_field(:summary, :find_with => "Summary")
  add_input_field(:content, :find_with => "conversation[contributions_attributes][0][content]")
end

module NewConversationPage 

end
RSpec.configuration.include NewConversationPage, :type => :acceptance
