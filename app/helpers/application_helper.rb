module ApplicationHelper
  def can_edit?(owner)
    return false if current_person.nil?
    
    return true if (current_person.admin || current_person == owner)
  end
end
