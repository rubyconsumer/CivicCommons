class EmbedlyService

  attr_reader :properties
  attr_reader :error

  def initialize(embedly = nil)
    clear_state
    if embedly.nil?
      @embedly = Embedly::API.new(key: Civiccommons::Config.embedly['key'])
    else
      @embedly = embedly
    end
  end

  def fetch(url)
    clear_state
    begin
      objs = @embedly.objectify(url: url)
      @properties = objs[0].marshal_dump
      raise @properties[:error_message] if @properties.has_key?(:error_message)
    rescue Exception => e
      @properties = nil
      @error = e.message
      Rails.logger.error e.message
    end
  end

  def fetch_and_merge_params!(params)
    if params.is_a?(Hash) && params.has_key?(:contribution) && params[:contribution].has_key?(:url)
      fetch(params[:contribution][:url])
      unless properties.nil?
        params[:contribution][:embedly_type] = properties[:type]
        params[:contribution][:embedly_code] = raw
        params[:contribution][:url] = properties[:url]
      end
    end
  end

  def raw
    @properties.to_json
  end

  def self.parse_raw(raw)
    JSON.parse(raw)
  end

protected

  def clear_state
    @error = nil
    @properties = nil
  end

end
