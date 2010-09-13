module ConversationsHelper
  def format_rating(conversation)
    return "Rate this contribution" if conversation.nil? || conversation.total_rating.nil?
    return "+"+conversation.total_rating.to_s if conversation.total_rating >0
    return "-"+conversation.total_rating.to_s if conversation.total_rating <0  
    return "0"
  end

  def format_time(t)
     return "no particular time" if t.nil?
     return t.localtime.strftime("%c")
  end
  
  def format_time_only(t)
    return t.localtime.strftime("%r") unless t.nil?
  end
end
