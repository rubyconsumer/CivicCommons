class AddPublishDateToContentItems < ActiveRecord::Migration
  def self.up
    add_column :content_items, :published, :datetime
  end

  def self.down
    remove_column :content_items, :published
  end
end
