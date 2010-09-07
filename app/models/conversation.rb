class Conversation < ActiveRecord::Base
  include Rateable
  include Visitable
  
  has_many :contributions
  has_one  :top_level_contribution
  accepts_nested_attributes_for :top_level_contribution, :allow_destroy => true
  accepts_nested_attributes_for :contributions, :allow_destroy => true

  has_and_belongs_to_many :guides, :class_name => 'Person', :join_table => 'conversations_guides', :association_foreign_key => :guide_id
  has_and_belongs_to_many :issues
  has_and_belongs_to_many :events
  
  belongs_to :moderator, :class_name => 'Person'

  # paperclip bug: if you don't specify the path, you will get
  # a stack overflow when trying to upload an image.
  # return an open File object that contains our Amazon S3 credentials.
  filename = '/data/TheCivicCommons/shared/config/amazon_s3.yml' # the way it lands on EngineYard
  filename = Rails.root + 'config/amazon_s3.yml' unless File.exist? filename
  s3_credential_file = File.new(filename)

  has_attached_file :image,
    :styles => {
       :thumb => "100x100#",
       :small => "150x150>",
       :normal => "480x300" },
    :storage => :s3,
    :s3_credentials => s3_credential_file,
    :path => ":attachment/:id/:style/:filename"

  search_methods :containing_issue, :containing_guide

  scope :containing_guide,
    lambda {|target| joins(:guides).map{|x| (x.first_name + x.last_name).includes? target}}

  scope :containing_issue,
    lambda {|target|
     joins("inner join posts on conversations.id = posts.conversable_id inner join issues on posts.postable_id = issues.id").
      where("posts.postable_type = 'Issue'").
      where("lower(issues.description) like ?", "%" + target.downcase.strip + "%")}

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

