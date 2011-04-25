class CreateManagedIssuePages < ActiveRecord::Migration
  def self.up
    create_table :managed_issue_pages do |t|
      t.integer :issue_id, :null => false
      t.string :name, :null => false
      t.integer :created_by, :null => false
      t.text :content, :null => false

      t.string :cached_slug

      t.timestamps
    end
    add_index :managed_issue_pages, :issue_id
    add_index :managed_issue_pages, :cached_slug, :unique => true
  end

  def self.down
    drop_table :managed_issue_pages
  end
end
