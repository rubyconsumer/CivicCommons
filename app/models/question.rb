class Question < ActiveRecord::Base
  belongs_to :person, :foreign_key=>"owner"
  belongs_to :postable, :polymorphic => true
  has_many :posts, :as => :conversable
  
  validates :content, :presence=>true  
  
  def rating
    self.posts.where({:postable_type=>Rating.to_s}).inject{|sum, rating| sum + rating.rating} || 0
  end  
    
  def Question.create_for_conversation(params, conversation_id, owner)  
    return Post.create_post(params, conversation_id, owner, Conversation, Question)
  end
end
