class SetupManagedIssueSubclass < ActiveRecord::Migration
  def self.up
    add_column :issues, :type, :string, :null => false, :default => "Issue"
    add_column :issues, :managed_issue_page_id, :integer, :null => true
  end

  def self.down
    remove_column :issues, :managed_issue_page_id
    remove_column :issues, :type
  end
end
