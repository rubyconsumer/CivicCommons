class EmbedlyService

  # http://embed.ly/
  # https://pro.embed.ly/
  # http://explore.embed.ly/
  # http://api.embed.ly/

  attr_reader :properties
  attr_reader :error
  attr_reader :error_code

  def initialize(embedly = nil)
    clear_state
    if embedly.nil?
      @embedly = Embedly::API.new(key: Civiccommons::Config.embedly['key'])
    else
      @embedly = embedly
    end
  end

  def fetch(url, opts = {})
    clear_state
    begin
      opts[:url] = url
      objs = @embedly.objectify(opts)
      @properties = objs[0].marshal_dump
      raise @properties[:error_message] if @properties.has_key?(:error_message)
    rescue Exception => e
      @error = e.message
      if not @properties.nil? and @properties.has_key?(:error_code)
        @error_code = @properties[:error_code].to_i
      else
        @error_code = 500
        @error = "Server Issues"
      end
      @properties = nil
      Rails.logger.error e.message
    end
  end

  def fetch_and_merge_params!(params)
    fetch(params[:contribution][:url])
    unless properties.nil?
      params[:contribution][:embedly_type] = properties[:type]
      params[:contribution][:embedly_code] = raw
      params[:contribution][:url] = properties[:url]
    end
    return (not properties.nil?)
  end

  ### Error Code Convenience Methods
  
  def ok?
    @error_code == 200
  end

  def bad_request?
    @error_code == 400
  end

  def forbidden?
    @error_code == 403
  end

  def not_found?
    @error_code == 404
  end

  def server_issues?
    @error_code == 500
  end

  def not_implemented?
    @error_code == 501
  end

  def raw
    @properties.to_json
  end

  ### Utility Methods

  def load(data)
    @properties = EmbedlyService.parse_raw(data)
    return self
  end

  def self.parse_raw(data)
    
    if not data.is_a?(Hash)
      data = data.embedly_code if data.is_a?(EmbedlyContribution)
      begin
        data = JSON.parse(data)
      rescue JSON::ParserError 
        data = {}
      end
    end
    
    data.keys.each do |key|
      if not key.is_a?(Symbol)
        new_key = key.to_sym
        data[new_key] = data[key]
        data.delete(key)
        if data[new_key].is_a?(Hash)
          data[new_key] = self.parse_raw(data[new_key])
        end
      end
    end
    
    return data
  end

  def to_html
    EmbedlyService.to_html(properties)
  end

  def self.to_html(code)

    html = nil
    code = self.parse_raw(code)

    if code.has_key?(:oembed) and not code.has_key?(:error_code)
      if code[:oembed].has_key?(:html)
        html = code[:oembed][:html]
      elsif code[:oembed][:type] == 'photo'
        html = self.generate_img_html(code[:oembed])
      elsif code[:oembed][:type] == 'link'
        html = self.generate_link_html(code[:oembed][:url], code[:oembed][:title])
      else
        html = self.generate_link_html(code[:url], code[:title])
      end
    end

    return html
  end

  def to_thumbnail
    EmbedlyService.to_thumbnail(properties)
  end

  def self.to_thumbnail(code)

    html = nil
    code = self.parse_raw(code)

    if code.has_key?(:oembed)
      html = self.generate_thumbnail_html(code[:oembed])
    end

    return html
  end

  def to_fancybox
    EmbedlyService.to_thumbnail(properties)
  end

  def self.to_fancybox(code)
    # http://fancybox.net/

    #<a id="inline" href="#data">thumbnail</a>
    #<div style="display:none"><div id="data">embed</div></div>

    #<a id="single_image" href="image_big.jpg"><img src="image_small.jpg" alt=""/></a>

    html = nil
    code = self.parse_raw(code)

    if code.has_key?(:oembed)

      r = 1000 + rand(9000)
      
      html = "
        <script type='text/javascript'> 
          //<![CDATA[
            $(document).ready(function() {
              $(\"a#single_image-#{r}\").fancybox();
              $(\"a#inline-#{r}\").fancybox();
            });
          //]]>
        </script>
      "
      
      if code[:oembed][:type] == 'photo'
        html << "<a id=\"single_image-#{r}\" href=\""
        html << code[:oembed][:url]
        html << '">'
        html << self.to_thumbnail(code)
        html << '"</a>'
      else
        html << "<a id=\"inline-#{r}\" href=\"#data-#{r}\">"
        html << self.to_thumbnail(code)
        html << '</a>'
        html << "<div style=\"display:none\"><div id=\"data-#{r}\">"
        html << self.to_html(code)
        html << '</div></div>'
      end
    end

    return html
  end

  protected

  def clear_state
    @error_code = 200
    @error = nil
    @properties = nil
  end

  def self.generate_img_html(opts)
    html = '<img'
    html << " src=\"#{opts[:url]}\"" if opts.has_key?(:url)
    html << " height=\"#{opts[:height]}\"" if opts.has_key?(:height)
    html << " width=\"#{opts[:width]}\"" if opts.has_key?(:width)
    html << " title=\"#{opts[:title]}\"" if opts.has_key?(:title)
    html << " alt=\"#{opts[:description]}\"" if opts.has_key?(:description)
    html << ' />'
    return html
  end

  def self.generate_thumbnail_html(opts)
    html = '<img'
    html << " src=\"#{opts[:thumbnail_url]}\"" if opts.has_key?(:thumbnail_url)
    html << " height=\"#{opts[:thumbnail_height]}\"" if opts.has_key?(:thumbnail_height)
    html << " width=\"#{opts[:thumbnail_width]}\"" if opts.has_key?(:thumbnail_width)
    html << " title=\"#{opts[:title]}\"" if opts.has_key?(:title)
    html << " alt=\"#{opts[:description]}\"" if opts.has_key?(:description)
    html << ' />'
    return html
  end

  def self.generate_link_html(url, title)
    html = ''
    if not url.nil? and not title.nil?
      html << '<a'
      html << " href=\"#{url}\""
      html << " title=\"#{title}\""
      html << '>'
      html << title
      html << '</a>'
    end
    return html
  end

end
