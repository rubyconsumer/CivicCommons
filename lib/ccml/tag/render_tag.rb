class CCML::Tag::RenderTag < CCML::Tag::SingleTag

  def initialize(opts, url = nil)
    super(opts, url)
    @renderer = MyRenderer.new
  end

  # Renders the requested partial template.
  # Raises CCML::Error::TemplateError if the partial does not exist.
  #
  # {ccml:render:partial path="layouts/create_conversation"}
  def partial
    return @renderer.partial(@opts[:path])
  end

  private

  # http://amberbit.com/blog/render-views-partials-outside-controllers-rails-3
  class MyRenderer < AbstractController::Base
    include AbstractController::Rendering
    include AbstractController::Layouts
    include AbstractController::Helpers
    include AbstractController::Translation
    include AbstractController::AssetPaths
    include ActionController::UrlWriter

    self.view_paths = "app/views"

    def partial(path)
      return render :partial => path
    rescue ActionView::MissingTemplate => e
      raise CCML::Error::TemplateError, e.message
    end

  end
end
