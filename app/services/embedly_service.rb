class EmbedlyService

  attr_reader :properties

  def initialize(embedly = nil)
    if embedly.nil?
      @embedly = Embedly::API.new( key: Civiccommons::Config.embedly['key'])
    else
      @embedly = embedly
    end
  end

  #TODO handle when url not found
  #TODO handle when embedly down
  def fetch(url)
    objs = @embedly.objectify(url: url)
    @properties = objs[0].marshal_dump
  end

  def fetch_and_merge_params!(params)
    #if params.is_a?(Hash) && params.has_key?(:contribution) && params[:contribution].has_key?(:url)
      fetch(params[:contribution][:url])
      unless properties.nil?
        params[:contribution][:embedly_type] = properties[:type]
        params[:contribution][:embedly_code] = raw
        params[:contribution][:url] = properties[:url]
      end
    #end
  end

  def raw
    @properties.to_json
  end

  def self.parse_raw(raw)
    JSON.parse(raw)
  end

end
