module TopicsHelper
  def render_issue_topics_sidebar
    render 'topics/issue_topic_sidebar', :topics => @topics
  end

  def issue_topic_filter(topic)
    active = @current_topic == topic
    css_class = active ? 'active' : ''
    topic_id = active ? nil : topic.id
    link_to raw("<span>#{topic.name}</span> <em>#{topic.issue_count}</em>"), issues_path(:topic => topic_id), :class=> css_class
  end

  def render_radioshow_topics_sidebar
    render 'topics/radioshow_topic_sidebar', :topics => @topics
  end

  def radioshow_topic_filter(topic)
    active = @current_topic == topic
    css_class = active ? 'active' : ''
    topic_id = active ? nil : topic.id
    link_to raw("<span>#{topic.name}</span> <em>#{topic.radioshow_count}</em>"), radioshow_index_path(:topic => topic_id), :class=> css_class
  end

end
