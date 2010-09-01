class Issue < ActiveRecord::Base
  include Rateable
  include Visitable
  
  belongs_to :person
  has_and_belongs_to_many :conversations
  
  validates :description, :presence => true, :length => { :minimum => 5 }  
  
  def Issue.add_to_conversation(issue, conversation)
    conversation.posts << Post.new({:postable=>issue})
    return issue    
  end    
end
