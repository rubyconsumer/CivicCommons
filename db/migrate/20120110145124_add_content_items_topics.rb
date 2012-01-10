class AddContentItemsTopics < ActiveRecord::Migration
  def self.up
    create_table :content_items_topics, :id => false, :force => true do |t|
      t.integer :content_item_id
      t.integer :topic_id
      t.timestamps
    end
    add_index :content_items_topics, [:content_item_id, :topic_id]
  end

  def self.down
    remove_index :content_items_topics, [:content_item_id, :topic_id]
    drop_table :content_items_topics
  end
end
