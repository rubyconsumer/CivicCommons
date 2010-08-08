class Conversation < ActiveRecord::Base
  has_many :posts, :as => :conversable

  has_many :events
  has_and_belongs_to_many :guides, :class_name => 'People', :join_table => 'conversations_guides', :association_foreign_key => :guide_id
  
  def issues
    self.posts.where({:postable_type=>Issue.to_s}).collect{|x| x.postable}
  end
  
  def issues=(issues)
    self.posts.delete(self.posts.where(:postable_type=>Issue.to_s))
    issues.each do |issue|
      Issue.add_to_conversation(issue, self.id)
    end unless issues.nil?
  end

  # Return a comma-and-space-delimited list of the Issues
  # relevant to this Conversation, e.g., "Jobs, Sports, Religion"
  def issues_text
    if (issues.count > 0)
      r = ""
      issues.each do |issue|
        r += ", "
        r += issue.description
      end
      r[2,r.length-2] # lose starting comma-space
    else
      "No issues yet"
    end
  end

  # Original plan: single Moderator per Conversation.
  # New plan: Zero or more Guides per Conversation.
  # validates :moderator, :presence => :true

  def guides_text
    if (guides.count > 0)
      guides.join(", ")
    else
      "No Guides yet"
    end
  end

  #
  # Represent the "Started At" column in a reader-friendly format.
  #
  # This is kind of a kludge. It also doesn't properly say
  # "yesterday" when you're talking about New Year's Eve.
  def start_time_text
   if (started_at == nil)
     return "Don't know"
   end
   diff = started_at.yday - Time.now.yday
   sameyear = (started_at.year == Time.now.year)
   if (diff == 0 && sameyear)
     started_at.strftime("TODAY at %I:%M %p")
   elsif (diff == -1 && sameyear)
     started_at.strftime("YESTERDAY at %I:%M %p")
   else
     started_at.strftime("%A, %B %d, %Y at %I:%M %p")
   end
  end

  def start_month_text
    if started_at == nil
      "?"
    else
      started_at.strftime("%B")
    end
  end

  def start_day
    if started_at == nil
      "?"
    else
      started_at.mday
    end
  end
end

