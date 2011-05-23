class RemoveBinaryImageColumnFromConversation < ActiveRecord::Migration
  def self.up
    remove_column :conversations, :image
  end

  def self.down
    add_column :conversations, :image, :binary, :default => nil
  end
end
