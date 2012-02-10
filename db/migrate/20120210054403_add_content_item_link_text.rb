class AddContentItemLinkText < ActiveRecord::Migration
  def self.up
    add_column :content_items, :link_text, :string
  end

  def self.down
    remove_column :content_items, :link_text
  end
end
