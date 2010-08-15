class Issue < ActiveRecord::Base
  validates :description, :presence => true, :length => { :minimum => 5 }  
  has_and_belongs_to_many :conversations
  belongs_to :postable, :polymorphic => true
  
  def rating
    self.posts.where({:postable_type=>Rating.to_s}).inject{|sum, rating| sum + rating.rating} || 0
  end  
  
  def Issue.add_to_conversation(issue, conversation_id)
    conversation = Conversation.find(conversation_id)

    issue.errors.add "conversation_id", "The conversation could not be found." and return issue if conversation.nil? 
    
    conversation.posts << Post.new({:postable=>issue})
    conversation.save
    return issue    
  end
end
