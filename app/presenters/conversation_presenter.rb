class ConversationPresenter < PresenterBase

  def url
    conversation_url(@object, host: request.host)
  end

end
