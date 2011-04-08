class AddCachedSlugToContentItems < ActiveRecord::Migration
  def self.up
    add_column :content_items, :cached_slug, :string
    add_index  :content_items, :cached_slug, :unique => true
  end

  def self.down
    remove_column :content_items, :cached_slug
  end
end
