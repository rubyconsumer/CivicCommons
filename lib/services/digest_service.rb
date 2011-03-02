class Services::DigestService

  #TODO: Make a class for the digest data and return an array of that class
  #TODO: Use 'letter' param to segment the data set by first letter of last name
  #TODO: Optimize the data retrieval
  def generate_digest_set(letter = nil)

    digest_set = { }

    # set the time range
    time_range = (Time.now.midnight - 1.day)..(Time.now.midnight - 1.second)

    # get a list of digest_set people who are subscribed to the digest
    people = Person.where(:daily_digest => true)

    # get the list of conversations that were updated yesterday
    contrib = Contribution.where(:created_at => time_range).order('conversation_id ASC, id ASC')

    # extract the individual conversation ids
    convos = contrib.map { |c| c.conversation_id }
    convos.uniq!

    # get the subscriptions for each person
    people.each do |person|

      subscriptions = person.subscriptions

      digest = []

      subscriptions.each do |sub|

        # is the subscription in the list of current conversations?
        if convos.include? sub.subscribable_id
          digest.push sub.subscribable
        end
      end

      digest_set[person] = digest unless digest.empty?

    end

    return digest_set

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

end
