require 'parent_validator'

class Comment < ActiveRecord::Base
  include Rateable
  
  belongs_to :person, :foreign_key=>"owner"
  belongs_to :postable, :polymorphic => true
  has_many :posts, :as => :conversable
    
  validates :content, :presence=>true 
  
  def Comment.create_for_conversation(params, conversation_id, owner)  
    return Post.create_post(params, conversation_id, owner, Conversation, Comment)
  end
     
  def Comment.create_for_comment(comment_params, comment_id)  
    comment = Comment.new(comment_params)    
    parent_comment = Comment.find(comment_id)

    comment.errors.add "comment_id", "The parent comment could not be found." and return comment if parent_comment.nil? 
    
    if comment.save
      parent_comment.posts << Post.new({:postable=>comment})
      parent_comment.save
    end
    return comment
  end
end
