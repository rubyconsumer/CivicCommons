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
      text = Sanitize.clean(text, Sanitize::Config::RESTRICTED).strip
    end

    raw(truncate(text, :length => 150))
  end
end
