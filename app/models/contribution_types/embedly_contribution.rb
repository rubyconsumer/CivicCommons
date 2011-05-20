class EmbedlyContribution < Contribution

  validates :url, presence: true

  validates :embedly_code, presence: true
  validates :embedly_type, presence: true

  def base_url
    match = /^(?<base_url>http[s]?:\/\/(\w|[^\?\/:])+(:\d+)?).*$/i.match(url)
    return match.nil? ? nil : match[:base_url]
  end

end
