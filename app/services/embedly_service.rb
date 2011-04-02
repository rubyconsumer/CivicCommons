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
      new_key = key.to_sym
      data[new_key] = data[key]
      data.delete(key)
      if data[new_key].is_a?(Hash)
        data[new_key] = self.parse_raw(data[new_key])
      end
    end
    
    return data
  end

  def self.to_html(embedly, thumbnail = false)

    html = nil

    if not embedly.nil?
      
      code = self.parse_raw(embedly)

      if code.has_key?(:oembed)

        if thumbnail
          html = self.generate_thumbnail_html(code[:oembed])
        elsif code[:oembed].has_key?(:html)
          html = code[:oembed][:html]
        elsif code[:oembed][:type] == 'photo'
          html = self.generate_img_html(code[:oembed])
        elsif code[:oembed][:type] == 'link'
          # create some html
        end
      
      end
    end

    return html
  end

  def self.to_thumbnail(embedly)
    to_html(embedly, true)
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
  end

  def self.generate_thumbnail_html(opts)
    html = '<img'
    html << " src=\"#{opts[:thumbnail_url]}\"" if opts.has_key?(:thumbnail_url)
    html << " height=\"#{opts[:thumbnail_height]}\"" if opts.has_key?(:thumbnail_height)
    html << " width=\"#{opts[:thumbnail_width]}\"" if opts.has_key?(:thumbnail_width)
    html << " title=\"#{opts[:title]}\"" if opts.has_key?(:title)
    html << " alt=\"#{opts[:description]}\"" if opts.has_key?(:description)
    html << ' />'
  end

end
