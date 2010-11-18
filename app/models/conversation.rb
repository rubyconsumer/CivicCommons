class Conversation < ActiveRecord::Base
  include Rateable
  include Visitable
  include TopItemable
  include Subscribable
  include Regionable
  include GeometryForStyle
  
  has_many :contributions
  has_many(:confirmed_contributions, :class_name => 'Contribution',
           :conditions => ['confirmed = ?', true])
 
  has_many :top_level_contributions, :dependent => :destroy
  has_many :subscriptions, :as => :subscribable
  accepts_nested_attributes_for :top_level_contributions, :allow_destroy => true

  # any person that has made a contribution to the convo
  has_many(:participants, :through => :confirmed_contributions,
           :source => :person, :uniq => true,
           :order => "contributions.created_at ASC")

  has_and_belongs_to_many :guides, :class_name => 'Person', :join_table => 'conversations_guides', :association_foreign_key => :guide_id
  has_and_belongs_to_many :issues
  has_and_belongs_to_many :events
  
  has_attached_file :image,
    :styles => {
       :normal => "480x300#",
       :panel => "198x130#"},
    :storage => :s3,
    :s3_credentials => S3Config.credential_file,
    :path => IMAGE_ATTACHMENT_PATH,
    :default_url => '/images/convo_img_:style.gif'

  search_methods :containing_issue, :containing_guide
  
  scope :latest_updated, :order => 'updated_at DESC'

  scope :containing_guide,
    lambda {|target| joins(:guides).map{|x| (x.first_name + x.last_name).includes? target}}

  scope :containing_issue,
    lambda {|target|
     joins("inner join posts on conversations.id = posts.conversable_id inner join issues on posts.postable_id = issues.id").
      where("posts.postable_type = 'Issue'").
      where("lower(issues.name) like ?", "%" + target.downcase.strip + "%")}
  
  # Return a comma-and-space-delimited list of the Issues
  # relevant to this Conversation, e.g., "Jobs, Sports, Religion"
  def issues_text
    if issues.any?
       issues.map(&:name).join(", ")
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
