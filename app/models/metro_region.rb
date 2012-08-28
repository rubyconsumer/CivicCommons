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

  def self.metrocodes
    self.group(:metrocode)
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
end
