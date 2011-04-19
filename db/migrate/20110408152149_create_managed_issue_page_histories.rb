class CreateManagedIssuePageHistories < ActiveRecord::Migration
  def self.up
    create_table :managed_issue_page_histories do |t|
      t.integer :issue_page_id, :null => false
      t.integer :created_by, :null => false
      t.text :content, :null => false

      t.timestamps
    end
    add_index :managed_issue_page_histories, :issue_page_id
  end

  def self.down
    drop_table :managed_issue_page_histories
  end
end
