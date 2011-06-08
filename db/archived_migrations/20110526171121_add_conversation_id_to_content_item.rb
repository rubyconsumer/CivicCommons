class AddConversationIdToContentItem < ActiveRecord::Migration
  def self.up
    add_column :content_items, :conversation_id, :integer
  end

  def self.down
    remove_column :content_items, :conversation_id
  end
end
