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

end
