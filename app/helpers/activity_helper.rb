module ActivityHelper
  def render_recent_items_sidebar(recent_items=@recent_items)
    render 'shared/recent_items_sidebar', :recent_items => recent_items
  end
  
  def embed_activity_length
    @embed ? 250 : 100
  end
end
