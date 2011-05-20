class UpgradeTopItemToActivity < ActiveRecord::Migration
  def self.up
    #Update top_items table

    change_table :top_items do |t|
      t.timestamps
      t.integer :conversation_id, null: true
      t.integer :issue_id, null: true
      t.remove :recent_rating
      t.remove :recent_visits
    end
    add_index :top_items, :conversation_id, name: 'conversations_index'
    add_index :top_items, :issue_id, name: 'issues_index'

    #Populate conversation_id column

    top_items = TopItem.all
    top_items.each do |top_item|
      top_item.created_at = top_item.item_created_at
      if top_item.item.respond_to?(:conversation_id) && !top_item.item.conversation_id.nil?
        top_item.conversation_id = top_item.item.conversation_id
        top_item.save
      elsif top_item.item.respond_to?(:issue_id) && !top_item.item.issue_id.nil?
        top_item.issue_id = top_item.item.issue_id
        top_item.save
      elsif top_item.item.is_a?(Conversation)
        top_item.conversation_id = top_item.item_id
        top_item.save
      end
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Cannot reverse this migration."
  end
end
