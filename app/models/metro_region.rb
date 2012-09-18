class MetroRegion < ActiveRecord::Base

  has_many :conversations, :dependent => :restrict

  searchable do
    text :city_name, :boost => 3
    text :province, :boost => 1.2
    text :display_name, :boost => 1.1
    text :city_display_name,:boost => 1
    text :province_code, :boost => 0.9
  end

  def indexed_city_province_token
    "#{city_name.to_s.downcase.gsub(/\s/i, '-')}-#{province.to_s.downcase.gsub(/\s/i, '-')}"
  end

  def city_display_name
    "#{city_name}, #{province}"
  end

  def generate_slideout_image
    image = MiniMagick::Image.open("#{Rails.root}/public/images/regions/template.png")
    image.combine_options do |c|
      c.fill        'white'
      #c.font        'Helvetica'
      c.pointsize   '15'
      c.gravity     'center'
      c.annotate    '270', self.display_name
      c.trim        '+repage'
    end
    puts " * Generating image:#{self.metrocode}.png"
    image.format  "png"
    image.write   "#{Rails.root}/public/images/regions/#{self.metrocode}.png"

    "#{Rails.root}/public/images/regions/#{self.metrocode}.png"
  end

  def update_amazon_slideout_image
    puts "MetroRegion copy_slideout_to_amazon..."
    AWS::S3::Base.establish_connection!(
      :access_key_id     => S3Config.access_key_id,
      :secret_access_key => S3Config.secret_access_key,
    )

    slideout_image = self.generate_slideout_image
    AWS::S3::S3Object.store("#{self.metrocode}.png", open(slideout_image) , "#{S3Config.bucket}/images-regions")
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

  def self.metrocodes
    self.group(:metrocode)
  end

  def self.update_all_city_province_token
    MetroRegion.all.each do |metro_region|
      metro_region.city_province_token = metro_region.indexed_city_province_token
      metro_region.save(:validate => false)
    end
  end

  def self.search_city_province(q)
    q = q.to_s.gsub(/,|\./i,'') #remove comma
    q = q.gsub(/\s/i, '-') # sub whitespace into '-' because the tokens are using '-'
    MetroRegion.where("city_province_token LIKE '#{q}%'").order('city_province_token ASC').limit(50)
  end
end
