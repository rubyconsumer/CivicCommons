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

    truncated = truncate(text, :length => 200)
    highlighted = truncated.gsub(/(___)/, "<strong>").gsub(/~{2,}/, "</strong>").gsub(/~+/, "&nbsp;").gsub(/_{2,}/, "</strong>").gsub(/_+/, "&nbsp;")

    strong_start_index = highlighted.rindex(/\<(strong)\>/) || 0
    strong_end_index =  highlighted.rindex(/\<\/(strong)\>/) || 0

    if(strong_start_index > strong_end_index)
      # need to append /strong to string
      highlighted = highlighted + "</strong>"
    end 

    raw(highlighted)
  end

  private
  def text_containing_match(text)
    matched_text_start = text.index(/(___)/) || 0
    matched_text_end = text.rindex(/(~~~)/) || 0

    if(matched_text_start < 100)
      slice_start = 0
      slice_end = matched_text_end + 150
    else
      slice_start = matched_text_start - 50
      slice_end = matched_text_end + 200
    end
    text.slice!(slice_start..slice_end).strip
  end
end
