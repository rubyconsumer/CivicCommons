module Admin::FeaturedOpportunitiesHelper
  
  def featured_opportunity_options_for_select(record, selected, max_length=120)
    if record.present?
      array = record.collect do |r|
        [ strip_and_truncate(r.one_line_summary, max_length),
          r.id ]
      end
      array.unshift ['Select one...',nil]
    else
      array = []
    end
    options_for_select array, :selected => selected
  end
  
  def strip_and_truncate(text='', max_length=120)
    strip_tags(text).truncate(max_length)
  end
end
