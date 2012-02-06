namespace :content_item do

  desc 'migrate to HABTM conversations'
  task :migrate_conversations => :environment do
    
    puts "Fetching all ContentItem with conversation_id"
    content_items = ContentItem.where('conversation_id IS NOT NULL')
    puts "migrating #{content_items.count} content_Items"
    
    content_items.each do |content_item|
      ActiveRecord::Base.transaction do
        puts "content_item: #{content_item.title}"
        conversation = Conversation.find_by_id(content_item.conversation_id)
        puts "conversation: #{content_item.conversation_id}"
        content_item.conversations = [conversation] if !conversation.blank?
        content_item.update_attribute(:conversation_id,nil)
        puts "migrated #{content_item.title}"
      end
    end
    puts "Finished"
  end

end
