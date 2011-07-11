class CreateCuratedFeedItems < ActiveRecord::Migration
  def self.up
    create_table :curated_feed_items do |t|
      t.string :original_url, null: false
      t.string :provider_url
      t.string :title
      t.text :description
      t.datetime :pub_date
      t.text :raw
      t.integer :curated_feed_id
      t.timestamps
    end
  end

  def self.down
    drop_table :curated_feed_items
  end
end
