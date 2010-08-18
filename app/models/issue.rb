class Issue < ActiveRecord::Base
  validates :description, :presence => true, :length => { :minimum => 5 }  
  has_and_belongs_to_many :conversations
  belongs_to :postable, :polymorphic => true
  
  def rating
    self.posts.where({:postable_type=>Rating.to_s}).inject{|sum, rating| sum + rating.rating} || 0
  end  
  
  def Issue.add_to_conversation(issue, conversation)
    conversation.posts << Post.new({:postable=>issue})
    return issue    
  end

end
