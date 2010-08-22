module Visitable
  
  module ClassMethods
    def get_top_visited(limit = 10)
      self.where("last_visit_date >= '#{(Time.now - 30.days)}'").order("recent_visits DESC").limit(limit)
    end
  end
    
  def self.included(base)
    base.has_many :visits, :as => :visitable
    base.extend(ClassMethods)
  end
  
  def visit(user_id)  
    self.visits << Visit.new({:person_id=>user_id})
    self.total_visits = self.total_visits + 1
    self.last_visit_date = Time.now
    self.recent_visits = calculate_recent_visits    
  end
  
  def visit!(user_id)
    self.visit(user_id)
    self.save
  end
    
  def calculate_recent_visits
    self.visits.where("created_at >= '#{(Time.now - 30.days)}'").count
  end  
end

