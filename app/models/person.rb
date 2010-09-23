class Person < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :first_name, :last_name, :email, :password, :password_confirmation, :top, :zip_code, :admin, :validated

  has_many :contributions
  has_many :ratings
  has_and_belongs_to_many :conversations, :join_table => 'conversations_guides', :foreign_key => :guide_id
  has_and_belongs_to_many :events, :join_table => 'events_guides', :foreign_key => :guide_id

  validate :zip_code, :length => 10
  validates_numericality_of :top, :allow_nil => true

  scope :participants_of_issue, lambda{ |issue|
      joins(:conversations => :issues).where(['issue_id = ?',issue.id]).select('DISTINCT(people.id),people.*') if issue
    } 
  scope :proxy_accounts, where(:proxy => true)

  def name=(value)
    @name = value
    self.first_name, self.last_name = self.class.parse_name(value)
  end


  def name
    @name ||= "%s %s" % [self.first_name, self.last_name]
  end
  
  def full_name
    first_name.capitalize + " " + last_name.capitalize
  end

  def self.find_all_by_name(name)
    first, last = parse_name(name)
    where(:first_name => first, :last_name => last)
  end

  # FIXME: name parsing code is simplistic--won't handle "van Buren" and the like. Drops middle names.
  def self.parse_name(name)
    names = name.split(' ')
  end

  # Until we get some way to input real avatars, everyone's gonna look like George.
  def avatar_url(size)
    size = "small"
    return '/images/nemeth-avatar-small.png'
  end
  
  def create_proxy
    self.email = (first_name + last_name).gsub(/['\s]/,'').downcase + "@example.com"
    self.password = 'p4s$w0Rd'
    self.proxy = true
  end
end
