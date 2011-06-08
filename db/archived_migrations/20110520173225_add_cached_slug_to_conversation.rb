class AddCachedSlugToConversation < ActiveRecord::Migration
  def self.up
    add_column :conversations, :cached_slug, :string
    add_index  :conversations, :cached_slug, :unique => true
  end

  def self.down
    remove_column :conversations, :cached_slug
  end
end
