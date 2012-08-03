class MetroRegion < ActiveRecord::Base
  
  has_many :conversations, :dependent => :restrict
  
  searchable do
    text :city_name, :boost => 2, :default_boost => 2
    text :province
  end
  
  def city_display_name
    "#{city_name}, #{province}"
  end
  
end
