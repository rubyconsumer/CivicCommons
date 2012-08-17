module IssuesHelper
  def media_style(contribution)
    if contribution.is_image? #or contribution.embedly_type == "image"
      "image"
    elsif contribution.has_attachment?
      "document"
    elsif contribution.embedly_type == "video"
      "video"
    elsif not contribution.url.blank?
      "link"
    else
      "comment"
    end
  end

  def media_link_info(contribution)
    if contribution.has_attachment?
      link_to(contribution.attachment_file_name, contribution.attachment.url)
    else
      link_to(contribution.title, contribution.url)
    end
  end

  def source_url(issue)
    if issue.url.match(/^https?:/)
      issue.url
    else
      "http://" + issue.url
    end
  end

  def issue_node_path(contribution)
    issue_path(contribution.issue, anchor: "node-#{contribution.id}")
  end

  def issue_node_url(contribution, options = {})
    options ||= {}
    if Hash === options
      options[:anchor] ||= "node-#{contribution.id}"
    end
    issue_url(contribution.issue, options)
  end
end
