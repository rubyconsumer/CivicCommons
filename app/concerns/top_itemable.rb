module TopItemable
  
  def self.included(base)
    base.has_one :top_item, :as => :item
    base.after_create :create_top_item
  end
  
  def create_top_item
    #TopItem.create( :item => self )
  end
end