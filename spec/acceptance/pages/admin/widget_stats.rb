module CivicCommonsDriver
module Pages
class Admin
class WidgetStats
  SHORT_NAME = :admin_widget_stats
  include Page
  
  has_select(:week_of, 'week_of')
  has_link(:expand, 'Expand', :admin_widget_stat)
  
  class Show
    SHORT_NAME = :admin_widget_stat
    include Page
    include Database
    
    has_select(:week_of, 'week_of')
  end


end
end
end
end
