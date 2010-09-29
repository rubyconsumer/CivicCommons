module ApplicationHelper
  def can_edit?(owner)
    return false if current_person.nil?
    
    return true if (current_person.admin || current_person == owner)
  end

  def paginated_showing_info(collection, name_of_collection)
    "Showing %s of %s"%[collection.count,
                        pluralize(collection.total_entries, name_of_collection)]
  end

  def avatar_tag(person, options={})
    image_options = {
      :width => 50,
      :height => 50,
      :alt => "avatar",
      :title => person.name}.merge(options)
    image_tag(person.avatar_url("small"), image_options)
  end
end
