class AddUrlTitleColumnToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :url_title, :string
  end

  def self.down
    remove_column :issues, :url_title
  end
end
