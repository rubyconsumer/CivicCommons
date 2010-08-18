class TopItem  
  def TopItem.newest_items(limit=10)
    postables = Post.where("postable_type != 'Rating'").order("created_at DESC").limit(limit).collect{ |x| x.postable }    
    conversations = Conversation.order("created_at DESC").limit(limit)
    
    (postables | conversations).sort{|x,y| y.created_at <=> x.created_at}.first(limit)
  end
end
