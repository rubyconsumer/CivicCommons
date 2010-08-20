class Rating < ActiveRecord::Base
  belongs_to :person # who made this rating
  belongs_to :postable, :polymorphic => true
  validates :rating, :numericality => true, :inclusion => { :in => [-1,0,1] }
  
  def Rating.create_for_conversation(params, conversation_id, owner)  
    return Post.create_post(params, conversation_id, owner, Conversation, Rating)
  end  

  # Not quite working right. Keeping it in here for now while I wait for smarter people
  # to answer my stack overflow question. 
  
  # def Rating.rateable_objects
  #   rateable_objects = []
  #   ObjectSpace.each_object(Class) do |c|
  #     next unless c.include? Rateable
  #     rateable_objects << c
  #   end
  #   rateable_objects
  # end
end
