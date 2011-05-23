module ActivityHelper
  def render_recent_items_sidebar(recent_items=@recent_items)
    render 'shared/recent_items_sidebar', :recent_items => recent_items
  end
end
