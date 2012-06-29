class Admin::WidgetStatsController < Admin::DashboardController
  def index
    @week_of = params[:week_of] || 0
    @widget_stats = WidgetLog.find_all_url_summary_for_week(@week_of)
  end
  def show
    @widget_url = params[:widget_url]
    @week_of = params[:week_of] || 0
    @widget_stats = WidgetLog.find_one_url_summary_for_week(@widget_url, @week_of)
  end
end