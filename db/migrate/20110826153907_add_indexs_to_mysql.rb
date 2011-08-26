class AddIndexsToMysql < ActiveRecord::Migration
  def self.up
    if index_exists? :content_items, :content_type
      remove_index :content_items, column: :content_type
    end
    add_index :content_items, :content_type, length: 4
    if index_exists? :content_items, :cached_slug
      remove_index :content_items, column: :cached_slug
    end
    add_index :content_items, :cached_slug, length: 10

    add_index :contributions, :conversation_id
    add_index :contributions, :issue_id
    add_index :contributions, :owner

    add_index :conversations, :exclude_from_most_recent

    add_index :rating_groups, :conversation_id

    add_index :ratings, :rating_group_id
    add_index :ratings, :rating_descriptor_id

    add_index :visits, [:visitable_id, :visitable_type]
  end

  def self.down
    remove_index :content_items, column: :content_type
    add_index :content_items, :content_type
    remove_index :content_items, column: :cached_slug
    add_index :content_items, :cached_slug

    remove_index :contributions, column: :conversation_id
    remove_index :contributions, column: :issue_id
    remove_index :contributions, column: :owner

    remove_index :conversations, column: :exclude_from_most_recent

    remove_index :rating_groups, column: :conversation_id

    remove_index :ratings, column: :rating_group_id
    remove_index :ratings, column: :rating_descriptor_id

    remove_index :visits, column: [:visitable_id, :visitable_type]
  end
end
