class UpdateToNewCommentSchema < ActiveRecord::Migration
  def self.up
    drop_table :questions
    drop_table :answers
    drop_table :posts
    
    add_column :comments, :conversation_id, :integer
    add_column :comments, :comment_type, :text, :default => "Comment"
    add_column :comments, :target_person_id, :integer
    add_column :comments, :issue_id, :integer
  end

  def self.down
    create_table :questions
    create_table :answers
    create_table :posts
    remove_column :comments, :conversation_id
    remove_column :comments, :comment_type
    remove_column :comments, :target_person_id
    remove_column :comments, :issue_id
  end
end
