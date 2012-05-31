class DigestService

  attr_reader :digest_recipients,
              :digest_set,
              :updated_contributions,
              :updated_conversations,
              :updated_reflections

  def initialize
    @digest_set = { }
  end

  #TODO: Make a class for the digest data and return an array of that class
  #TODO: Use 'letter' param to segment the data set by first letter of last name
  #TODO: Optimize the data retrieval
  def generate_digest_set(letter = nil)
    get_digest_recipients
    get_updated_reflections
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

      unless set[person].empty?
        # send the email
        Notifier.daily_digest(person, conversations).deliver
      end

    end

  end

  def get_digest_recipients
    @digest_recipients = Person.where(:daily_digest => true)
  end
  
  def time_range
    # set the time range for yesterday
    (Time.now.midnight - 1.day)..(Time.now.midnight - 1.second)
  end

  def get_updated_contributions
    # get the list of conversations that were updated yesterday
    @updated_contributions = Contribution.confirmed.includes(:conversation).order('conversation_id ASC, id ASC').where(created_at: time_range).where(top_level_contribution: false)
  end

  def get_updated_conversations
    # extract the individual conversation ids
    @updated_conversations = @updated_contributions.map { |c| c.conversation }
    @updated_conversations += @updated_reflections.map { |c| c.conversation }
    
    @updated_conversations.uniq!
  end

  def get_updated_reflections
    @updated_reflections = Reflection.includes(:conversation).order('conversation_id ASC, id ASC').where(created_at: time_range)
  end


  def get_recipient_subscriptions
    # get the subscriptions for each person
    @digest_recipients.each do |person|

      subscriptions = person.subscriptions

      digest = []

      subscriptions.each do |sub|

        # is the subscription in the list of current conversations?
        if @updated_conversations.include? sub.subscribable
          digest << [sub.subscribable]
        end
      end

      @digest_set[person] = digest

    end

  end

  def group_contributions_by_conversation
    @digest_set.each do |person, conversations_array|

      conversations_array.each do |conversation|

        contributions = @updated_contributions.select do |contribution|
          contribution.conversation == conversation.first
        end
        
        reflections = @updated_reflections.select do |reflection|
          reflection.conversation == conversation.first
        end
        
        items = (contributions + reflections)

        conversation << items
      end
    end

    return @digest_set

  end

  def self.send_digest(letter = nil, set = nil)
    digest = self.new
    digest.generate_digest_set(letter)
    digest.process_daily_digest(set)
  end

end
