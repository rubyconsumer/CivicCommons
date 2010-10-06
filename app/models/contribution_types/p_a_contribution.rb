class PAContribution < Contribution
  include EmbeddedLinkable
  # only allow posts directly from people aggregator
  validates :url, :format => /^#{Civiccommons::PeopleAggregator.URL}\/some_url?.*post_id=[\d\w]+/
end
