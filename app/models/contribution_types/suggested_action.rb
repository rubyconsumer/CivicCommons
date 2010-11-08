class SuggestedAction < Contribution
  
  def editable_by?(user)
    return false if user.nil?
    (user.admin? || self.owner == user.id) && descendants_count == 0
  end
  
  def suggestion?
    true
  end
end
