class CreateManagedIssuePages < ActiveRecord::Migration
  def self.up
    create_table :managed_issue_pages do |t|
      t.string :name, :null => false
      t.integer :issue_id, :null => false
      t.integer :person_id, :null => false
      t.text :template, :null => false

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
