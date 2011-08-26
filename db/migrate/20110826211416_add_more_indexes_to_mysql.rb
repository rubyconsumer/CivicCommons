class AddMoreIndexesToMysql < ActiveRecord::Migration
  def self.up
    add_index :content_items, :person_id
    add_index :content_items, :conversation_id
    add_index :content_templates, :person_id
    add_index :conversations, :owner
    add_index :conversations_issues, [:conversation_id, :issue_id], unique: true
    add_index :curated_feed_items, :curated_feed_id
    add_index :managed_issue_pages, :person_id
    add_index :rating_groups, :person_id
    add_index :rating_groups, :contribution_id
    add_index :top_items, [:item_id, :item_type]
  end

  def self.down
    remove_index :content_items, column: :person_id
    remove_index :content_items, column: :conversation_id
    remove_index :content_templates, column: :person_id
    remove_index :conversations, column: :owner
    remove_index :conversations_issues, column: [:conversation_id, :issue_id]
    remove_index :curated_feed_items, column: :curated_feed_id
    remove_index :managed_issue_pages, column: :person_id
    remove_index :rating_groups, column: :person_id
    remove_index :rating_groups, column: :contribution_id
    remove_index :top_items, column: [:item_id, :item_type]
  end
end
