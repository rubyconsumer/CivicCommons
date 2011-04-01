class EmbedlyService

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

  def raw
    @properties.to_json
  end

  def self.parse_raw(data)
    data = JSON.parse(data) unless data.is_a?(Hash)
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

  def self.to_html(embedly)

    html = nil

    if not embedly.nil? and embedly.is_a?(EmbedlyContribution)

      code = self.parse_raw(embedly.embedly_code)

      if code.has_key?(:oembed)

        if code[:oembed].has_key?(:html)
          html = code[:oembed][:html]
        elsif code[:oembed][:type] == 'photo'
          # create some html
        elsif code[:oembed][:type] == 'link'
          # create some html
        end
      
      end
    end

    return html

  end

protected

  def clear_state
    @error_code = 0
    @error = nil
    @properties = nil
  end

end
