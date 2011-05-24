namespace :activity do

  desc 'Update existing records with current cache data'
  task :update_activity_cache => :environment do

    puts "Fetching all Activity Records"
    activity = Activity.all

    puts "Updating cached data"
    activity.each do |activity_item|
      activity_item.activity_cache = Activity.encode(activity_item.item)
      activity_item.save
    end

    puts "Activity items have been updated"

  end
end
