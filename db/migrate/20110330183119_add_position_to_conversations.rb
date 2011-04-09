class AddPositionToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :position, :integer
  end

  def self.down
    remove_column :conversations, :position
  end
end
