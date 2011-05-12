class CCML::Tag::RouteTag < CCML::Tag::SingleTag

  def initialize(opts, url = nil)
    super(opts, url)
    @writer = MyUrlWriter.new(@host)
  end

  # Returns the root RLurl
  # 
  # {ccml:route}
  def index
    return @writer.url(:root)
  end

  # Returns the full URL to the requested route.
  # Raises CCML::Error::TemplateError if the route is bad.
  #
  # {ccml:route:url route="issues"}
  # {ccml:route:url route="issue" id="1"}
  # {ccml:route:url route="issue" id="more-about-the-civic-commons"}
  def url
    return @writer.url(@opts[:route], @opts[:id])
  end

  # Returns the absolute path to the requested route.
  # Raises CCML::Error::TemplateError if the route is bad.
  #
  # {ccml:route:path route="issues"}
  # {ccml:route:path route="issue" id="1"}
  # {ccml:route:path route="issue" id="more-about-the-civic-commons"}
  def path
    return @writer.path(@opts[:route], @opts[:id])
  end

  private

  class MyUrlWriter < AbstractController::Base
    include ActionController::UrlWriter

    def initialize(host)
      default_url_options[:host] = host
    end

    def url(route, id)
      if id
        return send "#{route}_url".to_sym, id
      else
        return send "#{route}_url".to_sym
      end
    rescue RuntimeError => e
      return path(route, id)
    rescue ActionController::RoutingError => e
      raise CCML::Error::TemplateError, e.message
    end

    def path(route, id)
      if id
        return send "#{route}_path".to_sym, id
      else
        return send "#{route}_path".to_sym
      end
    rescue ActionController::RoutingError => e
      raise CCML::Error::TemplateError, e.message
    end

  end
end
