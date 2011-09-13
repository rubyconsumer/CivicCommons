class SearchService

  def initialize(search = nil)
    if search.nil?
      # called by search controller since nothing was passed in
      @search = Sunspot
    else
      # called by search spec since a mock was passed in
      @search = search
    end
  end

  def fetch_results(query = nil, *models)
    fields = accepted_fields(models)
    results = @search.search(models) do
      keywords(query) do
        highlight fields
      end
    end

    fetched_results = []
    results.each_hit_with_result do |hit, result| 
      fetched_results << hit
    end
    return fetched_results
  end

  def accepted_fields(models)
    fields = {}
    i = 0 
    models.each do |mod|
      case 
      when mod == Contribution then
        fields[i] = :content
      when mod == Conversation then
        fields[i] = :summary
      when mod == Person then
        fields[i] = :bio
      when mod == Issue then
        fields[i] = :summary
      when mod == ContentItem then
        fields[i] = :body
        i = i + 1
        fields[i] = :summary
      end
      i = i + 1
    end
    return fields
  end
end
