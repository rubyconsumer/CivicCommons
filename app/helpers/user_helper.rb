module UserHelper

  def classes(contribution)
    cls = ''

    if contribution.is_image? or contribution.embedly_type == 'image'
      cls = 'image dnld'
    elsif contribution.embedly_type == 'video'
      cls = 'video dnld'
    elsif contribution.has_attachment?
      cls = 'document dnld'
    elsif contribution.has_media?
      cls = 'link dnld'
    end

    return cls
  end

  def remote_url(url)
    url.gsub(/www\./, 'http://www.')
  end

  def url_to_contribution(contribution)
    if contribution.issue && ! ( controller.controller_name == 'issues' && controller.action_name == 'show' )
      issue_node_path( contribution )
    elsif contribution.conversation
      conversation_node_path( contribution )
    end
  end

end
