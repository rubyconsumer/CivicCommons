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

  def image(type = :normal)
    @target.respond_to?(:image) ? refine_image(type) : ""
  end

  def refine_image(type = :normal)
    @target.image.respond_to?(:url) ? @target.image.url(type) : @target.image
  end

end
