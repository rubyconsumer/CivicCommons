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
  
  # This method allows you to get the subset of direct descendents of this_contribution_id from the complete thread of root_contribution_and_descendents
  #  root_contribution in this case is a TopLevelContribution node, and the whole thing has already been loaded by the controller,
  #  so we don't want to poll the database for each subset when we've already loaded the entire set once.
  def display_direct_descendant_subset(root_contribution_and_descendants, this_contribution_id)
    out = ""
    root_contribution_and_descendants.descendants.select{ |c| c.parent_id == this_contribution_id }.sort_by{ |c| c.created_at }.each do |contribution|
      out += render(:partial => "conversations/contributions/#{contribution.type.underscore}", :locals => { :contribution => contribution })
    end
    raw(out)
  end
end
