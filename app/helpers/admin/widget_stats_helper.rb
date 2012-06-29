module Admin::WidgetStatsHelper
  def weeks_ago_date_range_select(week_ago = 8)
    week_range = (0..week_ago)
    selections = []
    week_range.each do |week|
      selections.push ["#{week.weeks.ago.beginning_of_week.to_s(:short_friendly_with_day_name)} - #{week.weeks.ago.end_of_week.to_s(:short_friendly_with_day_name)}", week]
      selections.push ['---------','none', :disabled => true] if first_week_of_month?(week)
    end
    selections
  end
  def url_for_widget_stat(widget_stat, *options)
    show_admin_widget_stats_path(widget_stat.url.gsub(/^\//i,''), *options)
  end
  def first_week_of_month?(week)
    beginning_week_date = week.weeks.ago.beginning_of_week
    (beginning_week_date.day / 7.0).ceil == 1 #need to round up the float to work
  end
end
