class AddTwitterAndWebsiteToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :twitter_username, :string
    add_column :people, :website, :string
  end

  def self.down
    remove_column :people, :website
    remove_column :people, :twitter_username
  end
end
