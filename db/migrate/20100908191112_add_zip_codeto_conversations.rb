class AddZipCodetoConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :zip_code, :string
  end

  def self.down
    remove_column :conversations, :zip_code
  end
end
