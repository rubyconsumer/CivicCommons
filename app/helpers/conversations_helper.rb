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
  
  def display_direct_descendant_subset(root_contribution_and_descendants, this_contribution_id)
    out = ""
    root_contribution_and_descendants.descendants.select{ |c| c.parent_id == this_contribution_id }.sort_by{ |c| c.created_at }.each do |contribution|
      out += render(:partial => "conversations/contributions/#{contribution.type.underscore}", :locals => { :contribution => contribution })
    end
    raw(out)
  end
end
