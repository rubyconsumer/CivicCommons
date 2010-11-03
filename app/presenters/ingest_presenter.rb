class IngestPresenter

  attr_reader :errors
  
  def initialize(conversation, file=nil)
    @conversation = conversation
    @file = file
    @errors = ActiveModel::Errors.new(self)
  end

  def save!
    if @file
    
      dialogs = Ingester.ingest(@file.read)
      
      # before creating top level contributions, validate that all
      # speakers have a unique Person
      validate_speakers(dialogs)
      
      dialogs.each do |dialog|
        speaker = Person.find_all_by_name(dialog.speaker).first
        contribution = TopLevelContribution.create!(:conversation => @conversation,
                                                    :content => dialog.content,
                                                    :person => speaker)
        
        @conversation.contributions << contribution
      end
    end
  rescue Ingester::Error => e
    @errors.add_to_base(e.message)
    raise ActiveRecord::RecordInvalid.new(self)
  end

  protected
  # Very primitive way of validating speakers
  # Adds errors if
  #  o can't identify a Person for the speaker
  #  o more than 1 Person matches a speaker
  #
  def validate_speakers(dialogs)
    missing_speakers = []
    duplicate_speakers = []
    dialogs.map(&:speaker).uniq.select do |name|
      people = Person.find_all_by_name(name)
      if people.empty?
        missing_speakers << name
      elsif people.size > 1
        duplicate_speakers << name
      end
    end
    if missing_speakers.any? || duplicate_speakers.any?
      missing_speakers.each do |name|
        @errors.add_to_base("Could not find a person with name #{name}")
      end
      duplicate_speakers.each do |name|
        @errors.add_to_base("More than one Person matched name #{name}")
      end
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

end
