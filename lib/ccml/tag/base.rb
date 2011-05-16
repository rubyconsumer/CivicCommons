module CCML
  module Tag

    class Base

      attr_reader :url
      attr_reader :host
      attr_reader :port
      attr_reader :resource
      attr_reader :path
      attr_reader :query_string
      attr_reader :segments
      attr_reader :fields

      attr_reader :opts

      attr_reader :renderer

      define_method(:qs) { return @query_string }
      define_method(:http?) { return @http }
      define_method(:https?) { return @https }

      URL_PATTERN = /^(?<protocol>http[s]?):\/\/(?<host>(\w|[^\?\/:])+)(:(?<port>\d+))?(?<resource>.*)$/i
      PATH_AND_QS_PATTERN = /(?<path>^\/[^\?]*)?\/?(\?(?<qs>\S*$))?/
      FIELD_AND_VALUE_PATTERN = /(?<field>[^=]+)=(?<value>[^&]+)\&?/
      SEGMENT_INDEX_PATTERN =/^segment_(?<index>\d+)$/i 
      LAST_SEGMENT_PATTERN = /^last_segment$/i 
      FIELD_INDEX_PATTERN = /^field_(?<index>\w+)$/i
      QUERY_STRING_PATTERN = /^query_string$/i

      def initialize(opts, url = nil)
        if opts.is_a?(Hash)
          @opts = opts
        else
          @opts = {}
        end
        parse_url(url)
        update_opts_from_url_segments
        update_opts_from_url_fields
        @renderer = MyRenderer.new(url)
      end

      def index
        raise CCML::Error::NotImplementedError, "You must override the index method in all #{self.class} subclasses."
      end

      private

      def parse_url(url)

        @segments = []
        @fields = {}

        # parse the url or die
        match = URL_PATTERN.match(url)
        return if match.nil?

        # get the main pieces
        @http = ( match[:protocol] == 'http' )
        @https = ! @http
        @host = match[:host]
        @port = match[:port]
        @resource = match[:resource]

        # get the path and query string
        match = PATH_AND_QS_PATTERN.match(@resource)
        @path = ( match[:path] =~ /^\/$/ ? nil : match[:path] )
        @path = @path[0, @path.size-1] if @path =~ /\/$/
        @query_string = match[:qs]

        # parse the path segments
        @segments = @path.split('/') unless @path.blank?
        @segments.shift if @segments[0].blank?

        # parse the query string fields
        unless @query_string.blank?
          matches = @query_string.scan(FIELD_AND_VALUE_PATTERN)
          matches.each do |match|
            @fields[match.first.to_sym] = match.last
          end
        end

      end

      def update_opts_from_url_segments
        @opts.each do |key, value|
          match = SEGMENT_INDEX_PATTERN.match(value.to_s)
          if match
            @opts[key] = @segments[match[:index].to_i]
          elsif value =~ LAST_SEGMENT_PATTERN
            @opts[key] = @segments.last
          end
        end
      end

      def update_opts_from_url_fields
        @opts.each do |key, value|
          match = FIELD_INDEX_PATTERN.match(value.to_s)
          if match
            @opts[key] = @fields[match[:index].to_sym]
          elsif value =~ QUERY_STRING_PATTERN
            @opts[key] = @query_string
          end
        end
      end

      private

      # http://amberbit.com/blog/render-views-partials-outside-controllers-rails-3
      class MyRenderer < AbstractController::Base
        # include Rails modules
        include AbstractController::Rendering
        include AbstractController::Layouts
        include AbstractController::Helpers
        include AbstractController::Translation
        include AbstractController::AssetPaths
        include Rails.application.routes.url_helpers

        include ActionView::Helpers::AssetTagHelper
        include ActionView::Helpers::TagHelper
        include ERB::Util

        # include local helpers
        Dir["#{Rails.root}/app/helpers/*_helper.rb"].each do |file|
          helper File.basename(file, '_helper.rb').to_sym
        end

        # set required Rails configuration values
        self.view_paths = "app/views"
        self.config.assets_dir = ''

        def initialize(url)
          match = /^http[s]?:(?<host>\/\/(\w|[^\?\/:])+(:\d+)?).*$/i.match(url)
          default_url_options[:host] = (match.nil? ? '/' : match[:host])
        end

      end

    end

  end
end
