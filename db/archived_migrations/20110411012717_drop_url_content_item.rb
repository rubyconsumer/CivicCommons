class DropUrlContentItem < ActiveRecord::Migration
  def self.up
    remove_column :content_items, :url
  end

  def self.down
    add_column :content_items, :url
  end
end
