module UserHelper

  def classes(contribution)
    return case contribution.contribution_type
      when :image, :video, :suggestion
        "#{contribution.contribution_type.to_s} dnld"
      when 'attached_file'
        "document dnld"
      when 'link'
        "#{contribution.contribution_type} dnld"
      else
        ''
    end
  end

end
