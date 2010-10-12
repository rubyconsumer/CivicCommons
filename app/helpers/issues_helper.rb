module IssuesHelper
  def media_style(contribution)
    if contribution.is_image?
      "image"
    elsif contribution.is_a?(AttachedFile)
      "document"
    elsif contribution.is_a?(Link)
      "link"
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
    elsif contribution.is_a?(Link)
      link_to(contribution.title, contribution.url)
    else 
     raw contribution.embed_target
    end
  end

  def source_url(issue)
    if issue.url.match(/^http:/)
      issue.url
    else
      "http://" + issue.url
    end
  end
end
