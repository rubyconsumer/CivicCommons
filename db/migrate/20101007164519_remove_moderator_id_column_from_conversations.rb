class RemoveModeratorIdColumnFromConversations < ActiveRecord::Migration
  def self.up
    remove_column :conversations, :moderator_id
  end

  def self.down
    add_column :conversations, :moderator_id, :integer
  end
end
