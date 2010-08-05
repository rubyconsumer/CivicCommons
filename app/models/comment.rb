require 'parent_validator'

class Comment < ActiveRecord::Base
  # validates_with ParentValidator
  belongs_to :commentable, :polymorphic => true  
  has_many :comments, :as => :commentable
  has_many :ratings, :as => :rateable
    
  validates :content, :presence=>true  
  
  def Comment.create_for_conversation(comment_params, conversation_id)  
    comment = Comment.new(comment_params)
    conversation = Conversation.find(conversation_id)

    comment.errors.add "conversation_id", "The conversation could not be found." and return comment if conversation.nil? 

    if comment.save
      conversation.comments << comment
      conversation.save
    end
    return comment
  end
end
