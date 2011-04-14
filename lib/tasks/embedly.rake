namespace :embedly do

  desc 'Update existing records that have links to embedly'
  task :update_links => :environment do
    contributions = Contribution.where(type: 'Link')
    contributions.each do |c|
      embedly = EmbedlyService.new
      embedly.fetch_and_update_attributes(c)
      c.type = "EmbedlyContribution"
      c.save
    end
  end

  desc 'Update existing records that have embeded code to embedly'
  task :update_embeded_snippets  => :environment do
    contributions = Contribution.where(type: 'EmbeddedSnippet')
    contributions.each do |c|
      embedly = EmbedlyService.new
      embedly.fetch_and_update_attributes(c)
      c.embed_target = ''
      c.type = "EmbedlyContribution"
      c.save
    end
  end

  desc 'Update existing embedly records'
  task :update_embedly => :environment do
    contributions = Contribution.where(type: 'EmbedlyContribution')
    contributions.each do |c|
      embedly = EmbedlyService.new
      embedly.fetch_and_update_attributes(c)
      c.save
    end
  end

  desc 'Update all'
  task :update_all => [:update_embeded_snippets, :update_links, :update_embedly]

end
