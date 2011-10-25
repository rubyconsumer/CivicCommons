class IssueTopics < ActiveRecord::Migration
  def self.up
    create_table :issues_topics, :id => false, :force => true do |t|
      t.integer :issue_id
      t.integer :topic_id
      t.timestamps
    end
    add_index :issues_topics, [:issue_id,:topic_id]
  end

  def self.down
    remove_index :issues_topics, [:issue_id,:topic_id]
    drop_table :issues_topics
  end
end