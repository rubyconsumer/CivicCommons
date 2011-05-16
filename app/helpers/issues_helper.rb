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
      link_to(contribution.attachment_file_name, contribution.attachment.url)
    elsif contribution.is_a?(AttachedFile)
      link_to(contribution.attachment_file_name, contribution.attachment.url)
    elsif contribution.is_a?(Link)
      link_to(contribution.title, contribution.url)
    else 
      link_to(contribution.title, contribution.url)
    end
  end

  def source_url(issue)
    if issue.url.match(/^http:/)
      issue.url
    else
      "http://" + issue.url
    end
  end

  def issue_node_path(contribution)
    issue_path(contribution.issue) + "#node-#{contribution.id}"
  end

  def issue_node_url(contribution)
    issue_url(contribution.issue, :anchor => "node-#{contribution.id}", :host => 'localhost:3000')
  end
end
