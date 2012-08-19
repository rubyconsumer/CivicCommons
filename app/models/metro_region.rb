class MetroRegion < ActiveRecord::Base
  
  has_many :conversations, :dependent => :restrict
    
  searchable do
    text :city_display_name,:boost => 2
  end
  
  def city_display_name
    "#{city_name}, #{province}"
  end
  
  def self.top_metro_regions(limit = 5)
    sql = <<-SQL 
      SELECT m.*, count(m.id) as count_mid from metro_regions m join conversations c on c.`metro_region_id` = m.id
      GROUP BY m.metrocode
      ORDER BY count_mid DESC 
      LIMIT #{limit}
    SQL
    
    MetroRegion.find_by_sql(sql)
  end
  
end
