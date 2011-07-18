namespace :avatar do

  desc 'Update existing records with avatar url'
  task :update_image_urls => :environment do

    puts "Fetching all People Records"
    people = Person.all

    puts "Updating avatar urls"
    people.each do |person|
      puts "updated #{person.name}'s avatar url"
      AvatarService.update_avatar_url_for(person)
    end

    puts "Avatar URLs have been updated"

  end

end
