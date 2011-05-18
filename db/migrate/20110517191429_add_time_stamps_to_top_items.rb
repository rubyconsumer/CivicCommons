class AddTimeStampsToTopItems < ActiveRecord::Migration
  def self.up
    add_column :top_items, :created_at, :datetime
    add_column :top_items, :updated_at, :datetime
  end

  def self.down
    remove_column :top_items, :created_at
    remove_column :top_items, :updated_at
  end
end
