class Person < ActiveRecord::Base

  include Regionable
  include GeometryForStyle

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  attr_accessor :skip_shadow_account, :organization_name, :send_welcome

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :first_name, :last_name, :email, :password, :password_confirmation, :top, :zip_code, :admin, :validated, 
                  :avatar, :organization_name

  has_many :contributions, :foreign_key => 'owner', :uniq => true
  has_many :ratings
  has_many :subscriptions
  has_and_belongs_to_many :conversations, :join_table => 'conversations_guides', :foreign_key => :guide_id
  has_and_belongs_to_many :events, :join_table => 'events_guides', :foreign_key => :guide_id

  has_many :contributed_conversations, :through => :contributions, :source => :conversation, :uniq => true
  has_many :contributed_issues, :through => :contributions, :source => :issue, :uniq => true

  validates_length_of :email, :within => 6..255, :too_long => "please use a shorter email address", :too_short => "please use a longer email address"
  validate :zip_code, :length => 10
  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/gif image/png image/jpg image/x-png image/pjpeg)

  has_attached_file :avatar,
    :styles => {
      :small => "20x20#",
      :medium => "40x40#",
      :standard => "70x70#",
      :large => "185x185#"},
    :storage => :s3,
    :s3_credentials => S3Config.credential_file,
    :default_url => '/images/avatar_70.gif',
    :path => ":attachment/:id/:style/:filename"
  

  scope :participants_of_issue, lambda{ |issue|
      joins(:conversations => :issues).where(['issue_id = ?',issue.id]).select('DISTINCT(people.id),people.*') if issue
    } 

  # Stubbed out. We will need ot distinguish between a person and an org
  scope(:exclude_people, :conditions => {:organization => true})
  scope(:exclude_organizations, :conditions => {:organization => false})
  
  scope :proxy_accounts, where(:proxy => true)


  after_create :create_shadow_account, :unless => :skip_shadow_account
  after_create :notify_civic_commons
  before_save :check_to_send_welcome_email
  after_save :send_welcome_email, :if => :send_welcome?
  after_destroy :delete_shadow_account, :unless => :skip_shadow_account
  
  def check_to_send_welcome_email
    @send_welcome = true if confirmed_at_changed? && confirmed_at_was.blank? && !confirmed_at.blank?
  end

  def create_shadow_account
    begin
      Rails.logger.info("Creating shadow account for user with email #{email}")
      if self.organization_name.blank?
        pa_person = PeopleAggregator::Person.create(id:                         id,
                                                    firstName:                  first_name,
                                                    lastName:                   last_name,
                                                    login:                      email,
                                                    password:                   encrypted_password,
                                                    email:                      email,
                                                    profilePictureWidth:        avatar_width_for_style(:large),
                                                    profilePictureHeight:       avatar_height_for_style(:large),
                                                    profilePictureURL:          avatar_url_without_timestamp(:large),
                                                    profileAvatarWidth:         avatar_width_for_style(:standard),
                                                    profileAvatarHeight:        avatar_height_for_style(:standard),
                                                    profileAvatarURL:           avatar_url_without_timestamp(:standard),
                                                    profileAvatarSmallWidth:    avatar_width_for_style(:medium),
                                                    profileAvatarSmallHeight:   avatar_width_for_style(:medium),
                                                    profileAvatarSmallURL:      avatar_url_without_timestamp(:medium))

      else
        Rails.logger.info("Creating group named #{organization_name} for shadow account #{email}")
        pa_person = PeopleAggregator::Organization.create(id:                         id,
                                                          firstName:                  first_name,
                                                          lastName:                   last_name,
                                                          login:                      email,
                                                          password:                   encrypted_password,
                                                          email:                      email,
                                                          profilePictureWidth:        avatar_width_for_style(:large),
                                                          profilePictureHeight:       avatar_height_for_style(:large),
                                                          profilePictureURL:          avatar_url_without_timestamp(:large),
                                                          profileAvatarWidth:         avatar_width_for_style(:standard),
                                                          profileAvatarHeight:        avatar_height_for_style(:standard),
                                                          profileAvatarURL:           avatar_url_without_timestamp(:standard),
                                                          profileAvatarSmallWidth:    avatar_width_for_style(:medium),
                                                          profileAvatarSmallHeight:   avatar_width_for_style(:medium),
                                                          profileAvatarSmallURL:      avatar_url_without_timestamp(:medium),
                                                          groupName:                  organization_name)

      end
    rescue PeopleAggregator::Error => e
      errors.add(:person, e.message)
      raise ActiveRecord::RecordNotSaved
    end


    save_pa_identifier(pa_person)
  end


  def avatar_width_for_style(style)
    geometry_for_style(style, :avatar).width.to_i
  end

  def avatar_height_for_style(style)
    geometry_for_style(style, :avatar).height.to_i
  end


  def delete_shadow_account
    Rails.logger.info("Deleting shadow account for user with email #{email}")

    pa_person = PeopleAggregator::Person.find_by_email(self.email)
    pa_person.destroy

  end


  def name=(value)
    @name = value
    self.first_name, self.last_name = self.class.parse_name(value)
  end

  def name
    @name ||= ("%s %s" % [self.first_name, self.last_name]).titlecase.strip
  end
  
  def notify_civic_commons
    Notifier.new_registration_notification(self).deliver
  end
  
  def send_welcome?
    @send_welcome
  end

  def send_welcome_email
    Notifier.welcome(self).deliver
    @send_welcome = false
  end

  def self.find_all_by_name(name)
    first, last = parse_name(name)
    where(:first_name => first, :last_name => last)
  end

  # Takes a full name and return an array of first and last name
  # Examples
  #  "Wendy" => ["Wendy", ""]
  #  "Wendy Smith" => ["Wendy", "Smith"]
  #  "Wendy van Buren" => ["Wendy", "van Buren"]
  #
  def self.parse_name(name)
    first, *last = name.split(' ')
    last = last.try(:join, " ") || ""
    return first, last
  end

  def create_proxy
    self.email = (first_name + last_name).gsub(/['\s]/,'').downcase + "@example.com"
    self.password = 'p4s$w0Rd'
    self.proxy = true
  end
  
  def subscriptions_include?(subscribable)
    subscriptions.map(&:subscribable).include?(subscribable)
  end


  def avatar_url_without_timestamp(style='')
    self.avatar.url(style).gsub(/\?\d+$/, '')
  end


  private

  def save_pa_identifier(pa_person)
    Rails.logger.info("Success.  Person created.  Updating Person with People Agg ID...")
    self.people_aggregator_id = pa_person.id
    self.save
  end
end
