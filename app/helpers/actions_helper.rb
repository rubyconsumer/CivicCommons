module ActionsHelper
  def moderate_link_for(action)
    case action
    when Petition
      edit_url = edit_conversation_petition_url(action.conversation, action)
      delete_url =  conversation_petition_url(action.conversation, action)
    else
      edit_url = ''
      delete_url = ''
    end
    raw "<p class=\"fl-right alert alert-admin\">&nbsp;<strong>Moderate:</strong> #{link_to "Edit", edit_url} | #{link_to 'Delete', delete_url, :method => :delete, :confirm => 'Are you sure you want to delete this?'}</p>"
  end
end