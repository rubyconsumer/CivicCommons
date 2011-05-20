class CCML::Tag::RenderTag < CCML::Tag::SingleTag

  # Renders the requested partial template.
  # Raises CCML::Error::TemplateError if the partial does not exist.
  #
  # {ccml:render:partial path="layouts/create_conversation"}
  def partial
    return @renderer.render :partial => @opts[:path]
  end
end
