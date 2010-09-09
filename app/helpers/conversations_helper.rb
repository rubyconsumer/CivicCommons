module ConversationsHelper
  def format_rating(postable)
    return "0" if postable.nil? || postable.total_rating.nil?
    return "+"+postable.total_rating.to_s if postable.total_rating >0
    return "-"+postable.total_rating.to_s if postable.total_rating <0  
    return "0"
  end

  def format_time(t)
     return "no particular time" if t.nil?
     return t.localtime.strftime("%c")
  end
end
