class UpdateToNewCommentSchema < ActiveRecord::Migration
  def self.up
    drop_table :questions
    drop_table :answers
    drop_table :posts
    
    change_table :comments do |t|
      t.text :comment_type, :default => "Comment"
      t.integer :target_person_id
    end
  end

  def self.down
  end
end
