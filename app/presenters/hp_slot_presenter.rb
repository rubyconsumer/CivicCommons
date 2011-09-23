include Rails.application.routes.url_helpers

class HPSlotPresenter
  include Enumerable

  def initialize(target)
    @target = target
  end

  def title
    @target.respond_to?(:title) ? @target.title : nil
  end

  def url
    return issue_path(@target) if @target.is_a?(Issue)
    return conversation_path(@target) if @target.is_a?(Conversation)
    return content_path(@target) if @target.is_a?(ContentItem)
    return "/"
  end

  def image
    @target.respond_to?(:image) ? @target.image : ""
  end
end
