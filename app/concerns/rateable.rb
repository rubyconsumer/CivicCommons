module Rateable
  
  def self.included(base)
    base.class_eval do
      has_many :ratings, :as => :rateable
      scope :with_user_rating, lambda { |user|
        select("#{quoted_table_name}.*, user_rating.rating as user_rating").
        joins("LEFT OUTER JOIN ratings AS user_rating ON user_rating.rateable_id = #{quoted_table_name}.id AND user_rating.rateable_type = '#{base}' AND user_rating.person_id = #{user.id}")
      }
    end
    
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def get_top_rated(limit = 10)
      self.where("last_rating_date >= '#{(Time.now - 30.days)}'").order("recent_rating DESC").limit(limit)
    end
  end
  
  def user_rating=(value)
    @user_rating = value
  end
  
  def user_rating
    # for some reason defined?(super) won't return true when it's defined!
    #defined?(super) ? super : nil
    begin
      @user_rating || super
    rescue NoMethodError
      nil
    end
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

