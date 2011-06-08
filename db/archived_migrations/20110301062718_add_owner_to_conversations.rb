class AddOwnerToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :owner, :integer
  end

  def self.down
    remove_column :conversations, :owner
  end
end
