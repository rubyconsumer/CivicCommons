namespace :embedly do

  desc 'Update existing records that have links to embedly'
  task :update_links => :environment do
    puts "Updating Links..."
    contributions = Contribution.where(type: 'Link')
    contributions.each do |c|
      embedly = EmbedlyService.new
      embedly.fetch_and_update_attributes(c)
      c.save
    end
    puts "Finished updating Links"
  end

  desc 'Update existing records that have embeded snippets to embedly'
  task :update_embeded_snippets  => :environment do
    puts "Updating Embedded Snippets..."
    contributions = Contribution.where(type: 'EmbeddedSnippet')
    contributions.each do |c|
      embedly = EmbedlyService.new
      embedly.fetch_and_update_attributes(c)
      c.save
    end
    puts "Finished updating Embedded Snippets"
  end

  desc 'Update existing embedly records'
  task :update_embedly => :environment do
    puts "Updating Embedly Contributions"
    contributions = Contribution.where('embedly_code IS NOT NULL')
    contributions.each do |c|
      embedly = EmbedlyService.new
      embedly.fetch_and_update_attributes(c)
      c.save
    end
    puts "Finished updating Embedly Contributions"
  end

  desc 'Update all'
  task :update_all => [:update_embeded_snippets, :update_links, :update_embedly]

end
