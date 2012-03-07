class AddSlugsToFriendlyIdModels < ActiveRecord::Migration
  def self.up
    add_column :content_items, :slug, :string
    add_index :content_items, :slug, unique: true

    add_column :content_templates, :slug, :string
    add_index :content_templates, :slug, unique: true

    add_column :conversations, :slug, :string
    add_index :conversations, :slug, unique: true

    add_column :curated_feeds, :slug, :string
    add_index :curated_feeds, :slug, unique: true

    add_column :issues, :slug, :string
    add_index :issues, :slug, unique: true

    add_column :managed_issue_pages, :slug, :string
    add_index :managed_issue_pages, :slug, unique: true

    add_column :people, :slug, :string
    add_index :people, :slug, unique: true
  end

  def self.down
    remove_column :content_items, :slug
    remove_column :content_templates, :slug
    remove_column :conversations, :slug
    remove_column :curated_feeds, :slug
    remove_column :issues, :slug
    remove_column :managed_issue_pages, :slug
    remove_column :people, :slug
  end
end
