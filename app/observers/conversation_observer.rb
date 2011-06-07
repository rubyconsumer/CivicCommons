class ConversationObserver < ActiveRecord::Observer

  observe :conversation

  def after_update(model)
    Rails.logger.info "~ ConversationObserver.after_update triggered."
    Achievements::Engine.execute(model, :update)
  end

  def after_save(model)
    Rails.logger.info "~ ConversationObserver.after_save triggered."
    Achievements::Engine.execute(model)
  end

end
