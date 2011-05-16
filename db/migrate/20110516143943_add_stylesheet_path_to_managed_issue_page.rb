class AddStylesheetPathToManagedIssuePage < ActiveRecord::Migration
  def self.up
    add_column :managed_issue_pages, :stylesheet_path, :string
  end

  def self.down
    remove_column :managed_issue_pages, :stylesheet_path
  end
end
