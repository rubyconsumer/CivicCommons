class AddUrlToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :url, :string
  end

  def self.down
    remove_column :issues, :url
  end
end