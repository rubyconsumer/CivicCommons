module IssuesHelper
  def media_style(contribution)
    if contribution.is_image?
      "image"
    elsif contribution.is_a?(AttachedFile)
      "document"
    else
      "video"
    end
  end

  def media_link_info(contribution)
    if contribution.is_image?
      image = image_tag(contribution.attachment.url(:thumb),
                        :alt => contribution.attachment_file_name,
                        :title => contribution.attachment_file_name)
      link_to(image, contribution.attachment.url)
    elsif contribution.is_a?(AttachedFile)
      link_to(contribution.attachment_file_name, contribution.attachment.url)
    else 
     raw contribution.embed_target
    end
  end
end
