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

  task :purge_abandoned_top_items => :environment do
    deleted = 0
    puts "Deleting ophaned top_items (probably from contributions, conversations, or issues that were manually deleted from teh db)..."
    TopItem.includes(:item).all.each do |ti|
      if ti.item.nil?
        deleted += 1 if ti.destroy
      end
    end
    puts "#{Time.now}: Deleted #{deleted} top_item(s) that were orphaned."
  end
  
end
