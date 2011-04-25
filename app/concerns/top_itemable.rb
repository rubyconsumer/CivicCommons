module TopItemable

  def self.included(base)
    base.has_one :top_item, :as => :item, :dependent => :destroy
    base.after_create :create_top_item, :unless => :unconfirmed_or_not_top_itemable?
    base.after_save :create_top_item, :if => :top_itemable_and_was_just_confirmed?
  end

  def unconfirmed_or_not_top_itemable?
    self.has_confirmed_set_to_false? || self.not_top_itemable?
  end

  def top_itemable_and_was_just_confirmed?
    ! self.not_top_itemable? && self.was_just_confirmed?
  end

  # Don't create top_items for anything that matches these conditions
  def not_top_itemable?
    self.is_a?(TopLevelContribution)
  end

  def has_confirmed_set_to_false?
    self.respond_to?(:confirmed) && !self.confirmed
  end

  def was_just_confirmed?
    self.respond_to?(:confirmed) && self.confirmed_changed? && self.confirmed
  end

end
