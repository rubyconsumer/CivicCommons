class RemoveIssueIdFromConversationsTable < ActiveRecord::Migration
  def self.up
    remove_column :conversations, :issue_id
  end

  def self.down
    add_column :conversations, :issue_id, :integer
  end
end
