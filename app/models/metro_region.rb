class MetroRegion < ActiveRecord::Base
  
  has_many :conversations, :dependent => :restrict
  
  searchable do
    text :city_display_name,:boost => 2
  end
  
  def city_display_name
    "#{city_name}, #{province}"
  end
  
end
