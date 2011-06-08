class AddFromCommunityToConversation < ActiveRecord::Migration
  def self.up
    add_column :conversations, :from_community, :boolean, :default => false
  end

  def self.down
    remove_column :conversations, :from_community
  end
end
