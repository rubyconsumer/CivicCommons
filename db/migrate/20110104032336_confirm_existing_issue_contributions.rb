class ConfirmExistingIssueContributions < ActiveRecord::Migration
  def self.up
    say "Confirming Issue contributions..."
      Issue.all.each do |issue|
        issue.contributions.unconfirmed.collect(&:confirm!)
      end
    say "Done!"
  end

  def self.down
  end
end
