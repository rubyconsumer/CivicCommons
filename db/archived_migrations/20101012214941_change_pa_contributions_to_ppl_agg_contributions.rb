class ChangePaContributionsToPplAggContributions < ActiveRecord::Migration
  def self.up
    Contribution.update_all("type = 'PplAggContribution'", "type = 'PAContribution'")
  end

  def self.down
    Contribution.update_all("type = 'PAContribution'", "type = 'PplAggContribution'")
  end
end
