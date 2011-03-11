module InvitesHelper
  def from_conversation_create_page?
    params[:conversation_created]
  end
end
