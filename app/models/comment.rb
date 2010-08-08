require 'parent_validator'

class Comment < ActiveRecord::Base
  # validates_with ParentValidator
  belongs_to :person, :foreign_key=>"owner"
  belongs_to :postable, :polymorphic => true
  has_many :posts, :as => :conversable
  
    
  validates :content, :presence=>true  
  
  def Comment.create_for_conversation(comment_params, conversation_id)  
    comment = Comment.new(comment_params)    
    conversation = Conversation.find(conversation_id)

    comment.errors.add "conversation_id", "The conversation could not be found." and return comment if conversation.nil? 
    
    if comment.save
      conversation.posts << Post.new({:postable=>comment})
      conversation.save
    end
    return comment
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
