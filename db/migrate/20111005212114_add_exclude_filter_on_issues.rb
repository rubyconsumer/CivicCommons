class AddExcludeFilterOnIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :exclude_from_result, :boolean, :default => false
  end

  def self.down
    remove_column :issues, :exclude_from_result
  end
end
