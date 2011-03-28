class EmbedlyContribution < Contribution

  validates :embedly_code, presence: true
  validates :embedly_type, presence: true

end
