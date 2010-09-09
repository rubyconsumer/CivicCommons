class ChangeColumnNameModeratorToModeratorIdOnConversations < ActiveRecord::Migration
  def self.up
    rename_column :conversations, :moderator, :moderator_id
  end

  def self.down
    rename_column :conversations, :moderator_id, :moderator
  end
end
