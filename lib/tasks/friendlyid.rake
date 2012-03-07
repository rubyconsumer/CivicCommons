namespace :friendlyid do

  task :upgrade => :environment do
    puts "Migrating `cached_slug` to `slug` column"

    models = [
      Conversation,
      ContentItem,
      ContentTemplate,
      CuratedFeed,
      Issue,
      ManagedIssuePage,
      Person
    ]

    models.each do |model|
      puts " - migrating #{model.to_s}"
      model.find_each do |instance|
        instance.slug = instance.cached_slug
        instance.save(false)
      end
    end
    
    puts "#{Time.now}: Migration complete."
  end

end
