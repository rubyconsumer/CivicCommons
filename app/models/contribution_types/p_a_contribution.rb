class PAContribution < Contribution
  include EmbeddedLinkable
  # only allow posts directly from people aggregator
  validates :url, :format => /^http:\/\/civiccommons\.digitalcitymechanics\.com\/some_url?.*post_id=[\d\w]+/
end
