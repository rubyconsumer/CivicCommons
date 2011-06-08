class CreateCuratedFeeds < ActiveRecord::Migration
  def self.up
    create_table :curated_feeds do |t|
      t.string :title, unique: true
      t.string :description, default: nil
      t.string :cached_slug, null: false
      t.timestamps
    end
    add_index :curated_feeds, :cached_slug, :unique => true
  end

  def self.down
    drop_table :curated_feeds
  end
end
