class AddCachedSlugToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :cached_slug, :string
    add_index  :issues, :cached_slug, :unique => true
  end

  def self.down
    remove_column :issues, :cached_slug
  end
end
