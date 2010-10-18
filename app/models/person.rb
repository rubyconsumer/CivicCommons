class Person < ActiveRecord::Base

  include Regionable

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  attr_accessor :skip_shadow_account, :organization_name

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

  validate :zip_code, :length => 10
  validates_attachment_presence :avatar
  
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
  after_destroy :delete_shadow_account, :unless => :skip_shadow_account


  def create_shadow_account
    begin
      Rails.logger.info("Creating shadow account for user with email #{email}")
      if self.organization_name.blank?
        pa_person = PeopleAggregator::Person.create(firstName:             first_name,
                                                    lastName:              last_name,
                                                    login:                 email,
                                                    password:              encrypted_password,
                                                    email:                 email,
                                                    profilePictureURL:     avatar_url_without_timestamp(:large),
                                                    profileAvatarURL:      avatar_url_without_timestamp(:standard),
                                                    profileAvatarSmallURL: avatar_url_without_timestamp(:medium))

      else
        Rails.logger.info("Creating group named #{organization_name} for shadow account #{email}")
        pa_person = PeopleAggregator::Organization.create(firstName:              first_name,
                                                          lastName:               last_name,
                                                          login:                  email,
                                                          password:               encrypted_password,
                                                          email:                  email,
                                                          profilePictureURL:      avatar_url_without_timestamp(:large),
                                                          profileAvatarURL:       avatar_url_without_timestamp(:standard),
                                                          profileAvatarSmallURL:  avatar_url_without_timestamp(:medium),
                                                          groupName:              organization_name)

      end
    rescue PeopleAggregator::Error => e
      errors.add(:person, e.message)
      raise ActiveRecord::RecordNotSaved
    end


    save_pa_identifier(pa_person)
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
