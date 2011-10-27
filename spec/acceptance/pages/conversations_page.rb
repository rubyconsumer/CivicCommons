require File.expand_path(File.dirname(__FILE__) + '/page_object')

class ConversationsPage < PageObject
  
  def path
    '/conversations'
  end

  def initialize(page)
    super(page)
    @url_base = "/conversations/"
  end

  def visit_conversations(conversation = nil)
    if conversation
      if conversation.respond_to?(:id)
        id = conversation.id
      else
        id = conversation.to_i
      end
      visit "#{@url_base}#{id}"
    else
      visit @url_base
    end
  end

end
