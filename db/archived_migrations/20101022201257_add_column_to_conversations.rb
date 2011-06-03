class AddColumnToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :video_url, :string
  end

  def self.down
    remove_column :conversations, :video_url
  end
end
