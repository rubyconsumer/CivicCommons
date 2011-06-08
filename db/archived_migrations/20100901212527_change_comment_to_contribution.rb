class ChangeCommentToContribution < ActiveRecord::Migration
  def self.up
    rename_table :comments, :contributions
    remove_column :contributions, :comment_type
    add_column :contributions, :contribution_type, :string, :default => "Contribution"
    rename_column :contributions, :comment_id, :contribution_id
  end 
  def self.down
    rename_table :contributions, :comments
    remove_column :comments, :contribution_type
    add_column :comments, :comment_type, :string, :default => "Comment"
    rename_column :comments, :contribution_id, :comment_id
  end
end
