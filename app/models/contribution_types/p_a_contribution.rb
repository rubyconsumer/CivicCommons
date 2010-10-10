class PAContribution < Contribution
  include EmbeddedLinkable
  
  CONTRIBUTION_URL = /^#{Civiccommons::PeopleAggregator.URL}\/some_url?.*post_id=[\d\w]+/
  
  # only allow posts directly from people aggregator
  validates :url, :format => CONTRIBUTION_URL
end
