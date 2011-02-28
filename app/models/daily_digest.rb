class DailyDigest

  attr_reader :mailing_list

  def initialize
    @mailing_list = Person.where(daily_digest: true)
  end

  def send_digest
    mailing_list.each do |person|
      updated_conversations = retrieve_updated_conversations(person)
      unless updated_conversations.empty?
        Notifier.daily_digest(person, updated_conversations).deliver
      end
    end
  end

  def retrieve_updated_conversations(person)
    time_range = (Time.now.midnight - 1.day)..Time.now.midnight
    conversations = Conversation.includes(:subscriptions).where('subscriptions.person_id' => person, 'conversations.updated_at' => time_range)
  end

end