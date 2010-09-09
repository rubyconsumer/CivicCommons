class UpdateToNewCommentSchema < ActiveRecord::Migration
  def self.up
    add_column :comments, :conversation_id, :integer
    add_column :comments, :comment_id, :integer
    add_column :comments, :comment_type, :text, :default => "Comment"
    add_column :comments, :target_person_id, :integer
    add_column :comments, :issue_id, :integer
  end

  def self.down
    remove_column :comments, :conversation_id
    remove_column :comments, :comment_id, :integer
    remove_column :comments, :comment_type
    remove_column :comments, :target_person_id
    remove_column :comments, :issue_id
  end
end
