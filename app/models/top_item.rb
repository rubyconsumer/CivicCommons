class TopItem  
  def TopItem.newest_items(limit=10)
    comments = Comment.order("created_at DESC AND comment_type='Comment'").limit(limit)
    conversations = Conversation.order("created_at DESC").limit(limit)
    # issues
    # questions
    # events
    
    (comments | conversations).sort{|x,y| y.created_at <=> x.created_at}.first(limit)
  end
  
  def TopItem.highest_rated(limit=10)
    top_rated = []
    [Comment,Issue,Event,Conversation,Question].each do |model_name|
      top_rated = (top_rated | model_name.get_top_rated(limit))
    end
        
    top_rated.sort{|x,y| y.recent_rating <=> x.recent_rating}.first(limit)
  end
  
  def TopItem.most_visited(limit=10)
    top_visited = []
    [Comment,Issue,Event,Conversation,Question].each do |model_name|
      top_visited = (top_visited | model_name.get_top_visited(limit))
    end
        
    top_visited.sort{|x,y| y.recent_visits <=> x.recent_visits}.first(limit)
  end
  
end