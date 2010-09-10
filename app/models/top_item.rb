class TopItem < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  belongs_to :person
  
  before_create :set_item_created_at
  before_create :set_item_recent_rating, :if => :item_rateable?
  before_create :set_item_recent_visits, :if => :item_visitable?
  
  def self.newest_items(limit=10)
    self.order("item_created_at DESC").limit(limit)
  end
  
  def TopItem.highest_rated(limit=10)
    self.order("recent_rating DESC").limit(limit)
  end
  
  def TopItem.most_visited(limit=10)
    self.order("recent_visits DESC").limit(limit)
  end
  
  protected
  
  def item_rateable?
    self.item.respond_to?(:recent_rating)
  end
  
  def item_visitable?
    self.item.respond_to?(:recent_visits)
  end
  
  def set_item_created_at
    self.item_created_at = self.item.created_at
  end
  
  def set_item_recent_rating
    self.recent_rating = self.item.recent_rating
  end
  
  def set_item_recent_visits
    self.recent_visits = self.item.recent_visits
  end
end