class AddEmbedCodeToContentItems < ActiveRecord::Migration
  def self.up
    add_column :content_items, :embed_code, :text, :null => true
  end

  def self.down
    remove_column :content_items, :embed_code
  end
end
