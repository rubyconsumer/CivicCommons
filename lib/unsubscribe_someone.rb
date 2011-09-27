module UnsubscribeSomeone
  def unsubscribe_from_daily_digest
    self.daily_digest = false
    save(:validate => false)
  end
  def subscribed_to_daily_digest?
    daily_digest
  end
end
