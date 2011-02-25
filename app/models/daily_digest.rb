class DailyDigest

  attr_reader :mailing_list

  def initialize
    @mailing_list = Person.where(daily_digest: true)
  end

end
