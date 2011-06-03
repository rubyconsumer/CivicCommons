class AddCachedSlugToUser < ActiveRecord::Migration
  def self.up
    add_column :people, :cached_slug, :string
    add_index  :people, :cached_slug, :unique => true
  end

  def self.down
    remove_column :people, :cached_slug
  end
end
