class Rating < ActiveRecord::Base
  belongs_to :person # who made this rating
  belongs_to :postable, :polymorphic => true
  validates :rating, :numericality => true, :inclusion => { :in => [-1,0,1] }
  
  def Rating.create_for_conversation(params, conversation_id, owner)  
    return Post.create_post(params, conversation_id, owner, Conversation, Rating)
  end  
end
