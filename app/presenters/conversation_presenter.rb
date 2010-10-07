class ConversationPresenter < Presenter::Base
  include Rails.application.routes.url_helpers


  def url
    conversation_url(@object, host: request.host)
  end


end
