module TopicsHelper
  def render_issue_topics_sidebar
    render 'topics/issue_topic_sidebar', :topics => @topics
  end
  
  def issue_topic_filter(topic)
    active = @current_topic == topic
    css_class = active ? 'active' : ''
    topic_id = active ? nil : topic.id
    link_to "#{topic.name} (#{topic.issue_count})", issues_path(:topic => topic_id), :class=> css_class
  end
end