module Rateable
  
  module ClassMethods
    
    def get_top_rated(limit = 10)
      self.where("last_rating_date >= '#{(Time.now - 30.days)}'").order("recent_rating DESC").limit(limit)
    end
  end
    
  def self.included(base)
    base.has_many :ratings, :as => :rateable
    base.extend(ClassMethods)
  end
    
  def rate(value, user)    
    @rating = Rating.new({:rating=>value})    
    @rating.person = user
    
    self.ratings << @rating
    
    self.total_rating ||= 0
    
    self.total_rating = self.total_rating + value
    self.last_rating_date = Time.now
    self.recent_rating = calculate_recent_rating    
  end
  
  def rate!(value, user)
    self.rate(value, user)
    if self.save
      self.user_rating = value if self.respond_to?(:user_rating)
      return true
    else
      self.errors[:rating] = @rating.errors if @rating.invalid?
      return false
    end
  end
    
  def calculate_recent_rating
    sum = 0
    self.ratings.where("created_at >= '#{(Time.now - 30.days)}'").each do |rating|
      sum = sum + rating.rating
    end
    return sum     
  end  
end

