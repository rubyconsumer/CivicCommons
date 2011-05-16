class CCML::Tag::RenderTag < CCML::Tag::SingleTag

  # Renders the requested partial template.
  #
  # {ccml:render:partial path="layouts/create_conversation"}
  def partial
    return @renderer.render :partial => @opts[:path]
  end
end
