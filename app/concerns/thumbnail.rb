module Thumbnail
  def custom_image?
    self.image && !self.default_image?
  end

  def default_image(style='original')
    if self.class.attachment_definitions[:image][:default_url]
      self.class.attachment_definitions[:image][:default_url].gsub(/\:style/, style).to_s
    else
      nil
    end
  end

  def default_image?(style='original')
    default_image = default_image(style)
    default_image && self.image.to_s == default_image
  end
end