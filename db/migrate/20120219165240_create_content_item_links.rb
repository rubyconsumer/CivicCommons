class CreateContentItemLinks < ActiveRecord::Migration
  def self.up
    create_table :content_item_links do |t|
      t.string :title
      t.text :description
      t.text :url
      t.integer :content_item_id

      t.timestamps
    end
    add_index :content_item_links, :content_item_id
  end

  def self.down
    remove_index :content_item_links, :content_item_id
    drop_table :content_item_links
  end
end