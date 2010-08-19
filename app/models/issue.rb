class Issue < ActiveRecord::Base
  include Rateable
  
  validates :description, :presence => true, :length => { :minimum => 5 }  

  belongs_to :postable, :polymorphic => true
  has_many :posts, :as => :conversable
  
  belongs_to :person
  
  def Issue.add_to_conversation(issue, conversation)
    conversation.posts << Post.new({:postable=>issue})
    return issue    
  end    
end
