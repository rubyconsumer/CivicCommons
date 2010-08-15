module ConversationsHelper
  def format_rating(postable)
    return "0" if postable.nil? || postable.rating.nil?
    return "+"+postable.rating.to_s if postable.rating >0
    return "-"+postable.rating.to_s if postable.rating <0  
    return "0"
  end
end
