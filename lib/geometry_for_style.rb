module GeometryForStyle
  def geometry_for_style(style=:original, method=:image)
    attachment = self.send(method)
    Paperclip::Geometry.parse(attachment.styles[style].geometry)
  end
end

