module Admin::ConversationsHelper

  def toggle_staff_pick_link(conversation)
    link_text = conversation.staff_pick? ? 'on' : 'off'
    full_link_text = "<span class=\"text\">#{conversation.position}</span>"
    link_to raw(full_link_text), toggle_staff_pick_admin_conversation_path(conversation, :redirect_to => action_name), :method => :put, :class => 'staff_pick ' +  link_text
  end

end
