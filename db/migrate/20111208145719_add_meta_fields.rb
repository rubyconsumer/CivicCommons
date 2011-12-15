class AddMetaFields < ActiveRecord::Migration
  def self.up
    add_column :conversations, :page_title,       :string
    add_column :conversations, :meta_description, :text
    add_column :conversations, :meta_tags,        :text

    add_column :issues, :page_title,       :string
    add_column :issues, :meta_description, :text
    add_column :issues, :meta_tags,        :text

    add_column :content_items, :page_title,       :string
    add_column :content_items, :meta_description, :text
    add_column :content_items, :meta_tags,        :text
  end

  def self.down
    remove_column :conversations, :page_title
    remove_column :conversations, :meta_description
    remove_column :conversations, :meta_tags

    remove_column :issues, :page_title
    remove_column :issues, :meta_description
    remove_column :issues, :meta_tags

    remove_column :content_items, :page_title
    remove_column :content_items, :meta_description
    remove_column :content_items, :meta_tags
  end

end
