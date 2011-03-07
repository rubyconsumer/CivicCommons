class Services::DigestService

  attr_reader :digest_recipients, :updated_contributions, :updated_conversations,
              :digest_set

  def initialize
    @digest_set = { }
  end

  #TODO: Make a class for the digest data and return an array of that class
  #TODO: Use 'letter' param to segment the data set by first letter of last name
  #TODO: Optimize the data retrieval
  def generate_digest_set(letter = nil)
    get_digest_recipients
    get_updated_contributions
    get_updated_conversations
    get_recipient_subscriptions
    group_contributions_by_conversation
  end

  def process_daily_digest(set = nil)

    # get the set of people receiving the digest email
    set = self.generate_digest_set if set.nil?

    # for each person
    set.each do |person, conversations|

      # send the email
      Notifier.daily_digest(person, conversations).deliver

    end

  end

  def get_digest_recipients
    @digest_recipients = Person.where(:daily_digest => true)
  end

  def get_updated_contributions
    # set the time range for yesterday
    time_range = (Time.now.midnight - 1.day)..(Time.now.midnight - 1.second)

    # get the list of conversations that were updated yesterday
    @updated_contributions = Contribution.includes(:conversation).where(:created_at => time_range).order('conversation_id ASC, id ASC')
  end

  def get_updated_conversations
    # extract the individual conversation ids
    @updated_conversations = updated_contributions.map { |c| c.conversation }
    @updated_conversations.uniq!
  end

  def get_recipient_subscriptions
    # get the subscriptions for each person
    digest_recipients.each do |person|

      subscriptions = person.subscriptions

      digest = []

      subscriptions.each do |sub|

        # is the subscription in the list of current conversations?
        if updated_conversations.include? sub.subscribable
          digest << [sub.subscribable]
        end
      end

      digest_set[person] = digest unless digest.empty?

    end

  end

  def group_contributions_by_conversation
    digest_set.each do |person, conversations_array|

      conversations_array.each do |conversation|

        contributions = updated_contributions.select do |contribution|
          contribution.conversation == conversation.first && contribution.person != person
        end

        conversation << contributions
      end
    end

    return digest_set

  end

end
