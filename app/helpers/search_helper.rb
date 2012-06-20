module SearchHelper
  def best_hit_description(hit, field_name)
    text = nil
    if highlight = hit.highlight(field_name)
      if(!highlight.nil?)
        text = highlight.format { |fragment|  "___" + fragment + "~~~" }
      end
    else
      text = hit.result.method(field_name).call
    end

    if(!text.nil?)
      clean_text = Sanitize.clean(text).strip
      text = text_containing_match clean_text
    end

    raw(text)
  end

  private
  def text_containing_match(text)
    matched_text_start = text.index(/(___)/) || 0
    matched_text_end = text.rindex(/(~~~)/) || 0

    # Get only text surrounding the matched elements
    if(matched_text_start < 100)
      slice_start = 0
      slice_end = matched_text_end + 150
    else
      slice_start = matched_text_start - 50
      slice_end = matched_text_end + 200
    end
    text = text.slice!(slice_start..slice_end).strip

    # truncate text so that it doesn't cut off the strong tags
    truncated = truncate(text, :length => 200)
    highlighted = truncated.gsub(/(___)/, "<strong>").gsub(/~{2,}/, "</strong>").gsub(/~+/, "&nbsp;").gsub(/_{2,}/, "</strong>").gsub(/_+/, "&nbsp;")
    highlighted = auto_close_strong_tag(highlighted)
    highlighted = append_ellipsis_if_missing(highlighted)
    return highlighted
  end

  def auto_close_strong_tag(text)
    # check if strong closing tag exists at the end of the string
    strong_start_index = text.rindex(/\<(strong)\>/) || 0
    strong_end_index =  text.rindex(/\<\/(strong)\>/) || 0

    if(strong_start_index > strong_end_index)
      # need to append closing strong tag to string since it was detected that an opening strong tag exists
      text += "</strong>"
    end
    return text
  end

  def append_ellipsis_if_missing(text)
    ellipsis_index = text.rindex(/\.{3}/)
    if(ellipsis_index == nil)
      text += "..."
    elsif(ellipsis_index < (text.length - 3))
      text += "..."
    end
    return text
  end
end
