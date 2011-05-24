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

  desc 'Update existing records with person data'
  task :update_people => :environment do

    puts "Fetching all Activity Records"
    activity = Activity.all

    puts "Updating activity records with person_id"
    activity.each do |activity_item|
      if activity_item.item.respond_to?(:owner)
        activity_item.person_id = activity_item.item.owner
        activity_item.save
      elsif activity_item.item.respond_to?(:person_id)
        activity_item.person_id = activity_item.item.person_id
        activity_item.save
      end
    end

    puts "Activity Records have been updated"
  end

end
