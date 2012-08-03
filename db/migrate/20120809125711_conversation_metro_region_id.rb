class ConversationMetroRegionId < ActiveRecord::Migration
  def self.up
    add_column :conversations, :metro_region_id, :integer
  end

  def self.down
    remove_column :conversations, :metro_region_id
  end
end