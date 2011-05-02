class AddExternalLinkToContentItems < ActiveRecord::Migration
  def self.up
    add_column :content_items, :external_link, :string
  end

  def self.down
    remove_column :content_items, :external_link
  end
end
