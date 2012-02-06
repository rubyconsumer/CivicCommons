class ContentItemConversations < ActiveRecord::Migration
  def self.up
    create_table :content_items_conversations, :id => false, :force => true do |t|
      t.integer :conversation_id
      t.integer :content_item_id
      t.timestamps
    end
    add_index :content_items_conversations, [:conversation_id,:content_item_id], :name => 'content_items_conversations_ids_index'
  end

  def self.down
    remove_index :content_items_conversations, :name => 'content_items_conversations_ids_index'
    drop_table :content_items_conversations
  end
end