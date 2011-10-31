module CivicCommonsDriver
module Pages
  class InviteAFriend
    SHORT_NAME = :invite_a_friend
    include Page

    def the_invite_a_friend_page_for_the? conversation
      has_content?("Invite a Friend") and has_content? conversation.title
    end
  end
end
end
