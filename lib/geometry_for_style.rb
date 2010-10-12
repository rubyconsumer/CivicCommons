module GeometryForStyle
  def geometry_for_style(style=:original)
    Paperclip::Geometry.parse(image.styles[style].geometry)
  end
end

