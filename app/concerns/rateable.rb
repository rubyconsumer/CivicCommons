module Rateable
  module ClassMethods
    def get_top_rated(limit = 10)
      self.where("last_rating_date >= '#{(Time.now - 30.days)}'").order("recent_rating DESC").limit(limit)
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def ratings
    self.posts.where({:postable_type=>Rating.to_s}).collect{|x| x.postable}
  end  
  
  def rate(value, user)    
    rating = Rating.new({:rating=>value})    
    rating.person = user
    
    post = Post.new()
    post.conversable = self
    post.postable = rating
    
    self.posts << post    
    
    self.total_rating = self.total_rating + value
    self.last_rating_date = Time.now
    self.recent_rating = calculate_recent_rating    
  end
  
  def rate!(value, user)
    self.rate(value, user)
    self.save
  end
    
  def calculate_recent_rating
    sum = 0
    self.posts.where("postable_type='#{Rating.to_s}' and created_at >= '#{(Time.now - 30.days)}'").each do |post|
      sum = sum + post.postable.rating
    end
    return sum     
  end 
end