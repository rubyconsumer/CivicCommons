class TopItem  
  def TopItem.newest_items(limit=10)
    postables = Post.where("postable_type != 'Rating'").order("created_at DESC").limit(limit).collect{ |x| x.postable }    
    conversations = Conversation.order("created_at DESC").limit(limit)
    
    (postables | conversations).sort{|x,y| y.created_at <=> x.created_at}.first(limit)
  end
  
  def TopItem.highest_rated(limit=10)
    top_rated = []
    [Comment,Issue,Event,Conversation,Question].each do |model_name|
      top_rated = (top_rated | model_name.get_top_rated)
    end
        
    top_rated.sort{|x,y| y.recent_rating <=> x.recent_rating}.first(limit)
  end
end