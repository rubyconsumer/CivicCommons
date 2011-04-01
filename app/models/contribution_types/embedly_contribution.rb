class EmbedlyContribution < Contribution

  validates :url, presence: true

  validates :embedly_code, presence: true
  validates :embedly_type, presence: true

end
