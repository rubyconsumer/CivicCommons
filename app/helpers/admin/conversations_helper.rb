module Admin::ConversationsHelper
  def toggle_staff_pick_link(conversation)
    link_text = conversation.staff_pick? ? 'on' : 'off'
    link_to link_text, toggle_staff_pick_admin_conversation_path(conversation, :redirect_to => action_name), :method => :put
  end
end
