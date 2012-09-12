require "highline/import"
require "mini_magick"
require 'aws/s3'


desc "Generate Metro Region Text Image for Region Filter Slideout"
task :generate_slideout_images => :environment do

  # Establish Amazon S3 Connection
  AWS::S3::Base.establish_connection!(
    :access_key_id     => S3Config.access_key_id,
    :secret_access_key => S3Config.secret_access_key,
  )

  MetroRegion.metrocodes.each do |region|
    slideout_image = region.generate_slideout_image
    AWS::S3::S3Object.store("#{region.metrocode}.png", open(slideout_image) , "#{S3Config.bucket}/images-regions")
  end
end

desc "index Metro region token into the database"
task :update_metro_region_city_province_token => :environment do
  puts "Updating MetroRegion's city_province_token"
  MetroRegion.update_all_city_province_token
end

