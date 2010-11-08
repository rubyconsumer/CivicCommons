class PplAggContribution < Contribution
  include EmbeddedLinkable
  
  CONTRIBUTION_URL = /^#{Civiccommons::PeopleAggregator.URL}\/content\/cid=[\d\w]+/
  
  # only allow posts directly from people aggregator
  validates :url, :format => CONTRIBUTION_URL
  
  def editable_by?(user)
    return false if user.nil?
    (user.admin? || self.owner == user.id) && descendants_count == 0
  end
end
