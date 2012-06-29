class WidgetLog < ActiveRecord::Base
  validates_presence_of :url, :remote_url
  
  def self.find_all_url_summary_for_week(week_of = 0)
    from_date, to_date = process_from_and_to_date(week_of)
    sql = <<-SQL 
      SELECT *, COUNT(id) AS page_views FROM 
      (SELECT * FROM widget_logs 
      WHERE created_at BETWEEN '#{from_date}' AND '#{to_date}'
      ORDER BY created_at DESC) AS t
      GROUP BY url
    SQL
    
    self.find_by_sql(sql)
  end
  
  def self.find_one_url_summary_for_week(url, week_of = 0)
    url = add_first_slash_if_doesnt_exist(url)
    from_date, to_date = process_from_and_to_date(week_of)
    sql = <<-SQL 
      SELECT *, COUNT(id) AS page_views FROM 
      (SELECT * FROM widget_logs 
        WHERE url = '#{url}'
        AND created_at BETWEEN '#{from_date}' AND '#{to_date}'
        ORDER BY created_at DESC
      ) AS t
      GROUP BY url, remote_url
      ORDER BY page_views DESC, url ASC
    SQL
    self.find_by_sql(sql)
  end
  
  def self.process_from_and_to_date(week_of=0)
    from_date = week_of.to_i.weeks.ago.beginning_of_week.utc.to_s(:db)
    to_date = week_of.to_i.weeks.ago.end_of_week.utc.to_s(:db)
    return from_date, to_date
  end
  def self.add_first_slash_if_doesnt_exist(url)
    url.gsub!(/^/,'/') if url.match(/^[^\/]/)
    return url
  end
end
