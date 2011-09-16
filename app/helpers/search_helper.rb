module SearchHelper
  def best_hit_description(hit, field_name)
    text = nil
    if highlight = hit.highlight(field_name)
      if(!highlight.nil?)
        text = highlight.format { |fragment| content_tag(:strong, fragment) }
      end
    else
      text = hit.result.method(field_name).call
    end

    if(!text.nil?)
      clean_text = Sanitize.clean(text, :elements => ['strong']).strip
      text = text_containing_match clean_text
    end

    raw(truncate(text, :length => 200))
  end

  private
  def text_containing_match(text)
    matched_text_start = text.index(/\<strong\>/) || 0
    matched_text_end = text.index(/\<\/strong\>/) || 0

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
