class PplAggContribution < Contribution
  include EmbeddedLinkable
  
  CONTRIBUTION_URL = /^#{Civiccommons::PeopleAggregator.URL}\/content\/cid=[\d\w]+/
  
  # only allow posts directly from people aggregator
  validates :url, :format => CONTRIBUTION_URL
end
