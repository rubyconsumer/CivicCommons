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
    fields[:fragment_size] = -1
    results = @search.search(models) do
      keywords(query) do
        highlight fields
      end
    end

    results.hits({ verify: true }).reject do |hit|
      hit.result.is_a?(Contribution) and not hit.result.confirmed?
    end
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
      when mod == ManagedIssuePage then
        fields[i] = :template
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
