class AddIndexSummaryToIssues < ActiveRecord::Migration
  def self.up
    change_table :issues do |t|
      t.text :index_summary
    end
    Issue.all.each { |issue| issue.update_attribute :index_summary, issue.summary }
  end

  def self.down
    remove_column :issues, :index_summary
  end
end
