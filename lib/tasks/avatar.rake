namespace :avatar do

  desc 'Update existing records with avatar url'
  task :update_url => :environment do

    puts "Fetching all People Records"
    people = Person.all

    puts "Updating avatar urls"
    people.each do |person|
      puts "updated #{person.name}'s avatar url"
      AvatarService.update_person(person)
    end

    puts "Avatar URLs have been updated"

  end

end
