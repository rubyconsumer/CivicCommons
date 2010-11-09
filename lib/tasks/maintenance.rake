namespace :maintenance do

  task :purge_contributions_and_rebuild_nested_set => :environment do
    deleted = 0
    puts "Deleting unconfirmed and invalid contributions..."
    Contribution.all.each do |c|
      if c.unconfirmed? || c.invalid?
        deleted +=1 if c.destroy
      end
    end
    puts "#{Time.now}: Deleted #{deleted} contribution(s)."
    puts "Now rebuilding nested set bounds (aka response associations and counts)..."
    Contribution.rebuild!
    puts "Done!"
  end
  
end