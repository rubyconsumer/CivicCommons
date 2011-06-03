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

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Cannot reverse this migration."
  end
end
