class AddActivityCacheToActivities < ActiveRecord::Migration
  def self.up
    change_table :top_items do |t|
      t.text :activity_cache
    end
  end

  def self.down
    remove_column :top_items, :activity_cache
  end
end
